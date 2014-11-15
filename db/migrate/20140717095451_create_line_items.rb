class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.integer :main_id
      t.integer :side_id
      t.belongs_to :cart, index: true

      t.timestamps
    end
  end
end
