class RequestsController < ApplicationController

  def new
    form_id = 2019071301
    @user = User.find(542)
    @forms = FormMaster.where(form_id: form_id)
    @form_title = FormMaster.where(form_id: form_id).where(name: 'title').first
  end

  def index
    @user = User.find(542)
    @requests = @user.requests
  end

end
