class AddColumnCommandToWorflows < ActiveRecord::Migration[5.2]
  def change
    add_column :workflows, :comment, :string
  end
end
