class AddColonyToUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :location_id
    add_column :users, :colony, :string
  end

  def self.down
    add_column :users, :location_id, :integer
    remove_column :users, :colony
  end
end
