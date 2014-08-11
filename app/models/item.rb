class Item < ActiveRecord::Base

  attr_accessor :vendor_name

  ## CONSTANTS ##
  scope :main, -> { where(category_id: Category.main_id) }
  scope :side, -> { where(category_id: Category.side_id) }

  ## VALIDATIONS ##
  validates :name, :price, :sku, :category, :vendor, presence: true
  
  ## ASSOCIATIONS ##
  belongs_to :vendor
  belongs_to :category
  has_many :items_menus
  has_many :items, through: :items_menus

  has_attached_file :image,
        :storage => :s3,
        :s3_credentials => {
          :bucket => "feedex",
          :access_key_id => 'AKIAJMUB6BJTAHZBBSEQ',
          :secret_access_key => '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'
        }

  validates_attachment_content_type :image, :content_type => %w(image/jpeg image/jpg image/png)

  has_attached_file :sold_out_image,
        :storage => :s3,
        :s3_credentials => {
          :bucket => "feedex",
          :access_key_id => 'AKIAJMUB6BJTAHZBBSEQ',
          :secret_access_key => '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'
        }

  validates_attachment_content_type :sold_out_image, :content_type => %w(image/jpeg image/jpg image/png image/JPEG)



  delegate :name, to: :category, prefix: true

  ## CALLBACKS ##
  before_validation :assign_vendor

  ## INSTANCE METHODS ##


  ## CLASS METHODS ##
  def self.available
    joins(:items_menus).where("items_menus.availability_time > date(?)", Time.now)
  end


  ## PRIVATE METHODS ##
  def assign_vendor
    self.vendor = Vendor.find_or_create_by_name(vendor_name)
    if vendor.new_record?
      errors.add(:vendor_name, "can't be blank")
    end
  end

end
