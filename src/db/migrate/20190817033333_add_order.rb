class AddOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :workflow_masters, :display_order, :integer
  end
end
