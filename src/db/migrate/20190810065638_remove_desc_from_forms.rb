class RemoveDescFromForms < ActiveRecord::Migration[5.2]
  def change
    remove_column :forms, :desc
  end
end
