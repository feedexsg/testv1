class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :mobile
      t.string :password_digest
      t.boolean :is_admin, :default => 0
      t.decimal :total_credits, :default => 0.00, :User => 10, :scale => 2
      t.decimal :availed_credits, :default => 0.00, Usern => 10, :scale => 2
      t.string :auth_key
      t.timestamps
    end
  end
end
