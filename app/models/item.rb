class Item < ActiveRecord::Base

  attr_accessor :vendor_name

  ## CONSTANTS ##


  ## VALIDATIONS ##
  validates :name, :price, :sku, :category, :vendor, presence: true
  
  ## ASSOCIATIONS ##
  belongs_to :vendor
  belongs_to :category
  has_attached_file :image,
        :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
        :url => "/system/:attachment/:id/:style/:filename"

  delegate :name, to: :category, prefix: true

  ## CALLBACKS ##
  before_validation :assign_vendor

  ## INSTANCE METHODS ##


  ## CLASS METHODS ##


  ## PRIVATE METHODS ##
  def assign_vendor
    self.vendor = Vendor.find_or_create_by_name(vendor_name)
    if vendor.new_record?
      errors.add(:vendor_name, "can't be blank")
    end
  end

end
