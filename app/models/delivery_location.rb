class DeliveryLocation < ActiveRecord::Base

  ## CONSTANTS ##


  ## VALIDATIONS ##
  validates :name, :delivery_timing, :colony, presence: true
  validates :name, uniqueness: { allow_blank: true, scope: :colony_id }

  ## ASSOCIATIONS ##
  belongs_to :colony

  delegate :name, to: :colony, prefix: true

  ## CALLBACKS ##


  ## INSTANCE METHODS ##


  ## CLASS METHODS ##

end
