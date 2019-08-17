class EnhanceFieldWidthMore2 < ActiveRecord::Migration[5.2]
  def change
    change_column :form_masters, :desc, :text
  end
end
