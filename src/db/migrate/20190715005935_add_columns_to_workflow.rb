class AddColumnsToWorkflow < ActiveRecord::Migration[5.2]
  def change
    add_column :workflows, :required, :boolean
    add_column :workflows, :flow_order, :integer
  end
end
