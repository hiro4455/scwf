class AddReferenceRequestToWorkflowMaster < ActiveRecord::Migration[5.2]
  def change
    add_reference :requests, :workflow_master
  end
end
