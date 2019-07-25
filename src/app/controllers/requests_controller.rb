class RequestsController < ApplicationController

  def index
    @user = @current_user
    @requests = @user.requests.where(in_progress: true)
    #@waiting_requests = Workflow.where(user:@user).where(approved: nil).select{|x| x.flow_step == x.request.current_step}.map{|x| x.request}.select{|x| not x.draft?}
    @waiting_requests = Workflow.where(user:@user).where(approved: nil).joins(:request).merge(Request.where(in_progress: true)).select{|x| x.flow_step == x.request.current_step}.map{|x| x.request}
    @my_requests = @user.requests.where(draft: nil)
    @workflow_masters = WorkflowMaster.all
  end

  def new
    @user = @current_user
    @users = User.all
    workflow_id = params[:workflow]
    @workflow = WorkflowMaster.find(workflow_id)
    @forms = @workflow.form_masters
    @form_title = @forms.find_by(behaviour: 'title')
    @steps = @workflow.workflow_step_masters
    @templates = @workflow.workflow_step_templates
  end

  def create
    #ActiveRecord::Base.transaction do
    user = @current_user
    user.requests.where(draft: true).destroy_all
    workflow = WorkflowMaster.find(params[:request][:workflow_id])
    forms = workflow.form_masters.all
    steps = workflow.workflow_step_masters
    request = user.requests.create(
      draft: true,
      in_progress: nil,
      workflow_master: workflow,
      status: '作成中',
      current_step: steps.first.flow_step,
      approving_step: workflow.approving_step,
      name: "#{workflow.name}")
    name = nil
    forms.each do |form|
      value = params[:request][form['name']]
      attached = nil
      if value.class.name == "ActionDispatch::Http::UploadedFile"
        attached = value
        value = attached.original_filename
      end
      new_form = request.forms.create(
        request: request,
        name: form['name'],
        column_type: form['column_type'],
        desc: form['desc'],
        required: form['required'],
        value: value,
        file: attached)
      name = "#{workflow.name}(#{params[:request][form['name']]})" if form.behaviour == 'subject'
    end
    request.update!(name: name) unless name.blank?

    steps.sort{|x| x.flow_step}.reverse.each do |step|
      authors = params[:request][step.flow_step.to_s].split(',')
      authors.each do |user_id|
        request.workflows.create(
          user: User.find(user_id),
          required: step.approve_type == "all",
          approved: nil,
          flow_step: step.flow_step)
      end
    end
    redirect_to confirm_request_path request
  end

  def confirm
    @user = @current_user
    @request = Request.find(params[:id])
    @workflow_master = @request.workflow_master
    @steps = @workflow_master.workflow_step_masters.all
    @forms = @request.forms
    @workflows = @request.workflows.all
    @need_sign = @request.workflows.where(user:@user).where(approved: nil)
  end

  def apply
    @request = Request.find(params[:id])
    @request.draft = nil
    @request.in_progress = true;
    @request.status = '申請中'
    @request.save!
    redirect_to requests_path
  end

  def review
    @user = @current_user
    @request = Request.find(params[:id])
    @workflow_master = @request.workflow_master
    @steps = @workflow_master.workflow_step_masters.all
    @forms = @request.forms
    @workflows = @request.workflows.all
    @need_sign = @request.workflows.where(user:@user).where(approved: nil)
  end

  def submit
    case params['commit']
    when 'approve'
      approve
    when 'reject'
      reject
    end
  end

  def approve
    request = Request.find(params[:id])
    request.current_workflow.approve_by!(@current_user, params['request']['comment'])
    request.update!(status: "承認", in_progress: nil) if request.approved?
    request.move_forward! if request.can_move_next?
    redirect_to requests_path
  end

  def reject
    request = Request.find(params[:id])
    request.current_workflow.reject_by!(@current_user, params['request']['comment'])
    request.update!(status: "却下", in_progress: nil)
    redirect_to requests_path
  end
end
