class CreateCredits < ActiveRecord::Migration
  def change
    create_table :credits do |t|
      t.decimal :amount, :precision => 10, :scale => 2
      t.string :source
      t.integer :user_id
      t.timestamps
    end
  end
end
