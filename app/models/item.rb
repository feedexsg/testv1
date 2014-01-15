class Item < ActiveRecord::Base

  ## CONSTANTS ##


  ## VALIDATIONS ##
  validates :name, :price, :category, :vendor, presence: true
  
  ## ASSOCIATIONS ##
  belongs_to :vendor
  belongs_to :category
  has_attached_file :image,
        :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
        :url => "/system/:attachment/:id/:style/:filename"

  delegate :name, to: :category
  delegate :name, to: :vendor

  ## CALLBACKS ##


  ## INSTANCE METHODS ##


  ## CLASS METHODS ##

end
