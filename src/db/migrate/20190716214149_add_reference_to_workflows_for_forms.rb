class AddReferenceToWorkflowsForForms < ActiveRecord::Migration[5.2]
  def change
    add_reference :form_masters, :workflow_master, index: true, forreign_key: true
  end
end
