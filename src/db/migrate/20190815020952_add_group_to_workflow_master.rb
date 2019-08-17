class AddGroupToWorkflowMaster < ActiveRecord::Migration[5.2]
  def change
    add_column :workflow_masters, :group, :string
  end
end
