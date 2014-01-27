class ItemsMenu < ActiveRecord::Base

  ## CONSTANTS ##


  ## VALIDATIONS ##
  validates :item, :menu, presence: true
  validates :item, uniqueness: { allow_blank: true, scope: :menu_id }

  ## ASSOCIATIONS ##
  belongs_to :item
  belongs_to :menu

  ## CALLBACKS ##


  ## INSTANCE METHODS ##


  ## CLASS METHODS ##

end
