class AddDraftToRequest < ActiveRecord::Migration[5.2]
  def change
    add_column :requests, :draft, :boolean
  end
end
