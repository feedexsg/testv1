class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.string :sku
      t.decimal :price, :precision => 2, :scale => 2
      t.has_attached_file :image
      t.integer :category_id
      t.integer :vendor_id
      t.timestamps
    end
  end
end
