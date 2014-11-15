class CreateSoldOuts < ActiveRecord::Migration
  def change
    create_table :sold_outs do |t|
      t.references :item, index: true

      t.timestamps
    end
  end
end
