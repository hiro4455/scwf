class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :mail
      t.string :type
      t.string :jigyoubu
      t.string :bumon
      t.string :ka
      t.string :job_class

      t.timestamps
    end
  end
end
