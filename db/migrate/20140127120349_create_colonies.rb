class CreateColonies < ActiveRecord::Migration
  def change
    create_table :colonies do |t|
      t.string :name
      t.timestamps
    end
  end
end
