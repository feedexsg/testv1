class Vendor < ActiveRecord::Base

  ## CONSTANTS ##


  ## VALIDATIONS ##
  validates :name, presence: true
  
  ## ASSOCIATIONS ##
  has_many :items

  ## CALLBACKS ##


  ## INSTANCE METHODS ##


  ## CLASS METHODS ##

end
