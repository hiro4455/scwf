class ChangeWorkflowInRequest < ActiveRecord::Migration[5.2]
  def change
    remove_column :requests, :workflow
    add_reference :requests, :workflow, index: true, forreign_key: true
  end
end
