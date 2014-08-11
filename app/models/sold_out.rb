class SoldOut < ActiveRecord::Base
  belongs_to :item

  has_attached_file :image,
        :storage => :s3,
        :s3_credentials => {
          :bucket => "feedex",
          :access_key_id => 'AKIAJMUB6BJTAHZBBSEQ',
          :secret_access_key => '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'
        }

  validates_attachment_content_type :image, :content_type => %w(image/jpeg image/jpg image/png)


end