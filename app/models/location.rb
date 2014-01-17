class Location < ActiveRecord::Base

  ## CONSTANTS ##


  ## VALIDATIONS ##
  validates :name, presence: true

  ## ASSOCIATIONS ##
  has_many :users

  ## CALLBACKS ##


  ## INSTANCE METHODS ##


  ## CLASS METHODS ##


end
