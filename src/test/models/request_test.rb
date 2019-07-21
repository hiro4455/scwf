require 'test_helper'

class RequestTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "request can create record" do
    request = Request.create(user: users(:one), workflow_master: workflow_masters(:one))
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
    request = Request.create(user: users(:one), workflow_master: workflow_masters(:one))
    workflow = request.workflows.create(user: users(:one))
    assert request.workflows.length == 1
  end

  test "request can move workflow" do
    request = requests(:can_move)

    # be sure to request was valid relations for workflow
    assert_not request.blank?
    assert_equal 'can_move', request.workflow_master.name
    assert_equal 3, request.workflow_master.workflow_step_masters.length
    assert_equal 5, request.workflows.length

    assert_equal 1, request.current_step
    first_step request
    second_step request
    third_step request
  end

  def first_step request
    assert_equal 1, request.current_step

    assert_equal false, request.can_move_next?

    request.current_workflow.approve_by!(users(:one))
    assert_equal true, request.can_move_next?

    request.move_forward!
    assert_equal 2, request.current_step
    new_request = requests(:can_move)
    assert_equal 2, new_request.current_step
  end
  def second_step request
    assert_equal 2, request.current_step

    assert_equal false, request.can_move_next?

    # It's test for approve type 'all'
    request.current_workflow.approve_by!(users(:one))
    assert_equal false, request.can_move_next?

    request.current_workflow.approve_by!(users(:two))
    assert_equal true, request.can_move_next?

    request.move_forward!
    assert_equal 3, request.current_step
  end
  def third_step request
    assert_equal 3, request.current_step

    assert_equal false, request.can_move_next?

    # It's test for approve type 'any'
    request.current_workflow.approve_by!(users(:one))
    assert_equal true, request.can_move_next?

    request.current_workflow.approve_by!(users(:two))
    assert_equal true, request.can_move_next?

    request.move_forward!
    assert_equal 3, request.current_step
  end


  test "request can approve" do
    request = requests(:can_move)

    # step 1
    assert_equal false, request.approved?
    request.move_forward!
    # step 2
    assert_equal false, request.approved?
    request.move_forward!
    # step 3
    assert_equal false, request.approved?
    request.current_workflow.approve_by! users(:one)
    assert_equal true, request.approved?
  end
end
