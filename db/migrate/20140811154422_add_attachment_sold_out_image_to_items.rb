class AddAttachmentSoldOutImageToItems < ActiveRecord::Migration
  def self.up
    change_table :items do |t|
      t.attachment :sold_out_image
    end
  end

  def self.down
    drop_attached_file :items, :sold_out_image
  end
end
