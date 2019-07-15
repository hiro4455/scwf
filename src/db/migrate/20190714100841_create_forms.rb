class CreateForms < ActiveRecord::Migration[5.2]
  def change
    create_table :forms do |t|
      t.references :request, foreign_key: true
      t.string :name
      t.string :column_type
      t.string :desc
      t.boolean :required
      t.string :value, limit: 1024

      t.timestamps
    end
  end
end
