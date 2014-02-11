class ItemsMenu < ActiveRecord::Base

  ## CONSTANTS ##
  attr_accessor :availability_time_select

  ## VALIDATIONS ##
  validates :item, presence: true
  validates :item, uniqueness: { allow_blank: true, scope: :menu_id }
  validate :assign_availablity_time

  ## ASSOCIATIONS ##
  belongs_to :item
  belongs_to :menu

  ## CALLBACKS ##


  ## INSTANCE METHODS ##


  ## CLASS METHODS ##


  ## PRIVATE METHODS ##
  def assign_availablity_time
    self.availability_time = Time.parse((menu.try(:available_on).try(:to_s) || Date.today.to_s) + " " + self.availability_time_select)
    return true
  end

end
