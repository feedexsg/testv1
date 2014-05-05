class RemoveColonyFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :colony, :string
    add_column :users, :colony_id, :integer
    add_index :users, :colony_id
  end
end
