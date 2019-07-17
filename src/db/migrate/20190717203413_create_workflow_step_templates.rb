class CreateWorkflowStepTemplates < ActiveRecord::Migration[5.2]
  def change
    create_table :workflow_step_templates do |t|
      t.references :workflow_master, foreign_key: true
      t.integer :template_id
      t.integer :flow_step
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :workflow_step_templates, :template_id
  end
end
