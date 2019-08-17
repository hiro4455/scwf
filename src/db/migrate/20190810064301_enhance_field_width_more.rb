class EnhanceFieldWidthMore < ActiveRecord::Migration[5.2]
  def change
    change_column :form_masters, :value, :text
  end
end
