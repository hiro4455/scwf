class RequestsController < ApplicationController

  def new
    form_id = 2019071301
    @user = User.find(542)
    @users = User.all
    @forms = FormMaster.where(form_id: form_id)
    @form_title = FormMaster.where(form_id: form_id).where(name: 'title').first
  end

  def index
    @user = User.find(542)
    @requests = @user.requests
    @waiting_requests = Workflow.where(user:@user).where(approved: nil).map{|x| x.request}
    @my_requests = @user.requests
  end

  def create
    user = User.find(542)
    forms = FormMaster.where(form_id: params[:request][:form_id])
    flow_number = 1
    request = user.requests.create(
      status: '申請中',
      current_step:  flow_number,
      name: params[:request][:title])
    forms.each do |form|
      request.forms.create(
        request: request,
        name: form['name'],
        column_type: form['column_type'],
        desc: form['desc'],
        required: form['required'],
        value: params[:request][form['name']])
    end
    request.workflows.create(
      user: User.find(params[:request]['author1']),
      required: params[:request]['required'],
      approved: nil,
      flow_step: flow_number)
  end

  def review
    @user = User.find(542)
    @request = Request.find(params[:id])
    @forms = @request.forms
    @workflows = @request.workflows.all
    @need_sign = @request.workflows.where(user:@user).where(approved: nil)
  end

  def approve
    @user = User.find(542)
    request = Request.find(params[:id])
    need_sign = request.workflows.where(user:@user).where(approved: nil)
    need_sign.each do |workflow|
      workflow.approved = true
      workflow.save
    end
    current = request.workflows.where(flow_step: request.current_step).all
    if current.all{|x| x.approved}
      new_flow = request.workflows.where("flow_step > ?", current.first.flow_step).first
      if new_flow.blank?
        request.status = '承認'
      else
        request.current_step = new_flow.flow_step
      end
      request.save
      redirect_to requests_path
    end
  end

end
