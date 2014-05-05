class Colony < ActiveRecord::Base

  has_many :users

  ## CONSTANTS ##


  ## VALIDATIONS ##
  validates :name, presence: true, uniqueness: { allow_blank: true }

  ## ASSOCIATIONS ##
  has_many :delivery_locations

  ## CALLBACKS ##


  ## INSTANCE METHODS ##


  ## CLASS METHODS ##

end
