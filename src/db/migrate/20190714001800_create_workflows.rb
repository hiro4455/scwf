class CreateWorkflows < ActiveRecord::Migration[5.2]
  def change
    create_table :workflows do |t|
      t.references :request, foreign_key: true
      t.references :user, foreign_key: false
      t.boolean :approved

      t.timestamps
    end
  end
end
