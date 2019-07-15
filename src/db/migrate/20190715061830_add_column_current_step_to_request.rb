class AddColumnCurrentStepToRequest < ActiveRecord::Migration[5.2]
  def change
    add_column :requests, :current_step, :integer
  end
end
