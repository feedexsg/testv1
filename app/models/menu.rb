class Menu < ActiveRecord::Base

  ## CONSTANTS ##


  ## VALIDATIONS ##
  validates :title, :available_on, presence: true, uniqueness: { allow_blank: true }

  ## ASSOCIATIONS ##
  has_many :items_menus
  has_many :items, through: :items_menus

  ## CALLBACKS ##


  ## INSTANCE METHODS ##


  ## CLASS METHODS ##

end
