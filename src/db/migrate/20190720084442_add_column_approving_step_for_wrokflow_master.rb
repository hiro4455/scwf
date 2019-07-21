class AddColumnApprovingStepForWrokflowMaster < ActiveRecord::Migration[5.2]
  def change
    add_column :workflow_masters, :approving_step, :integer
  end
end
