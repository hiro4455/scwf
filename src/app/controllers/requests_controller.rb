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
  end

  def create
    user = User.find(542)
    forms = FormMaster.where(form_id: params[:request][:form_id])
    request = user.requests.create
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
      flow_order: 1)

    #request.status = ''
    #request.name = params[:request]['title']
  end

end
