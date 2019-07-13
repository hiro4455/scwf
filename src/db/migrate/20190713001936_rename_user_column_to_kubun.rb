class RenameUserColumnToKubun < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :type, :kubun
  end
end
