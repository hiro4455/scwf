require 'test_helper'

class RequestTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "request can create record" do
    request = Request.create(user: users(:one))
    request.save
    created_request = Request.find(request.id)
    assert created_request.nil? == false
  end

  test "request has many workflows" do
    request = requests(:one)
    assert request.workflows.length == 2
    request = requests(:two)
    assert request.workflows.length == 0
  end

  test "request can create workflow" do
    request = Request.create(user: users(:one))
    result = request.save
    workflow = request.workflows.create
    workflow.save
    assert request.workflows.length == 1
  end
end
