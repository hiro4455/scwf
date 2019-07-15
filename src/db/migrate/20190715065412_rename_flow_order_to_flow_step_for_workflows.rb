class RenameFlowOrderToFlowStepForWorkflows < ActiveRecord::Migration[5.2]
  def change
    rename_column :workflows, :flow_order , :flow_step
  end
end
