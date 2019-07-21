class AddColumnApprovingStepForRequest < ActiveRecord::Migration[5.2]
  def change
    add_column :requests, :approving_step, :integer
  end
end
