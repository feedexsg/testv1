class AddAttachmentImageToSoldOuts < ActiveRecord::Migration
  def self.up
    change_table :sold_outs do |t|
      t.attachment :image
    end
  end

  def self.down
    drop_attached_file :sold_outs, :image
  end
end
