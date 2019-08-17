class EnhanceFieldWidth < ActiveRecord::Migration[5.2]
  def change
    change_column :form_masters, :value, :string, :limit => 1024
  end
end
