class ItemsMenu < ActiveRecord::Base

  ## CONSTANTS ##
  attr_accessor :availability_time_select

  ## VALIDATIONS ##
  validates :item, :menu, presence: true
  validates :item, uniqueness: { allow_blank: true, scope: :menu_id }

  ## ASSOCIATIONS ##
  belongs_to :item
  belongs_to :menu

  ## CALLBACKS ##


  ## INSTANCE METHODS ##


  ## CLASS METHODS ##


  ## PRIVATE METHODS ##
  def assign_availablity_time
    [:availability_time_select].each do |timeselect|
      self.write_attribute(timeselect.gsub("_select"), Time.parse(available_on.to_s + timeselect))
    end
    return true
  end

end
