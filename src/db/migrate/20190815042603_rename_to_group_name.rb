class RenameToGroupName < ActiveRecord::Migration[5.2]
  def change
    rename_column :workflow_masters, :group, :group_name
  end
end
