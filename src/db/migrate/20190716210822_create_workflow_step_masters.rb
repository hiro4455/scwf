class CreateWorkflowStepMasters < ActiveRecord::Migration[5.2]
  def change
    create_table :workflow_step_masters do |t|
      t.references :workflow_master, foreign_key: true
      t.string :name
      t.integer :flow_step
      t.string :name
      t.string :approve_type
      t.boolean :editable

      t.timestamps
    end
  end
end
