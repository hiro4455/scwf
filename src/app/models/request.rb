class Request < ApplicationRecord
  belongs_to :user
  belongs_to :workflow_master
  has_many :workflows, dependent: :destroy
  has_many :forms, dependent: :destroy

  class CurrentWrokflow
    def initialize(request)
      @request = request
      @workflows = request.workflows.where(flow_step: request.current_step)
    end

    def approve_by!(user)
      @workflows.where(user: user).where(approved: nil).each do |workflow|
        workflow.approved = true
        workflow.save
      end
    end

    def reject_by!(user)
      @workflows.where(user: user).where(approved: nil).each do |workflow|
        workflow.approved = false
        workflow.save
      end
    end
  end

  def current_workflow
    CurrentWrokflow.new(self)
  end

  def draft?
    draft == true
  end

  def can_move_next?
    current_step_master = workflow_master.workflow_step_masters.find_by(flow_step: current_step)
    current_approvals = workflows.where(flow_step: current_step).all
    case current_step_master.approve_type
    when 'all'
      current_approvals.all?{|x| x.approved == true}
    when 'any'
      current_approvals.any?{|x| x.approved == true}
    else
      raise "unknown approval type (#{current_step_master.approve_type})"
    end
  end

  def approved?
    step_master = workflow_master.workflow_step_masters.find_by(flow_step: approving_step)
    approvals = workflows.where(flow_step: approving_step).all
    case step_master.approve_type
    when 'all'
      approvals.all?{|x| x.approved == true}
    when 'any'
      approvals.any?{|x| x.approved == true}
    else
      raise "unknown approval type (#{step_master.approve_type})"
    end
  end

  def move_forward!
    workflows.where("flow_step > ?", current_step).order(:flow_step).limit(1).each do |next_step|
      self.current_step = next_step.flow_step
      self.save!
    end
  end
end
