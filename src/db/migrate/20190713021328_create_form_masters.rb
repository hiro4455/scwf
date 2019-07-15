class CreateFormMasters < ActiveRecord::Migration[5.2]
  def change
    create_table :form_masters do |t|
      t.integer :form_id
      t.string :column_type
      t.boolean :required
      t.integer :display_order
      t.string :metadata
      t.string :name
      t.string :desc
      t.string :value

      t.timestamps
    end
  end
end
