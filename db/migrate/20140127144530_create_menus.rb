class CreateMenus < ActiveRecord::Migration
  def change
    create_table :menus do |t|
      t.string :title
      t.date :available_on
      t.timestamps
    end
  end
end
