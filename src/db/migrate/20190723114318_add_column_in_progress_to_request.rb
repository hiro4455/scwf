class AddColumnInProgressToRequest < ActiveRecord::Migration[5.2]
  def change
    add_column :requests, :in_progress, :boolean
    add_index :requests, :in_progress
  end
end
