class Menu < ActiveRecord::Base

  ## CONSTANTS ##
  attr_accessor :start_timeselect, :end_timeselect
  Operation = {"Open" => 1, "Closed" => 0}

  ## VALIDATIONS ##
  validates :title, :available_on, presence: true, uniqueness: { allow_blank: true }

  ## ASSOCIATIONS ##
  has_many :items_menus
  has_many :main_items_menus
  has_many :side_items_menus
  has_many :items, through: :items_menus
  accepts_nested_attributes_for :items_menus, allow_destroy: true

  ## CALLBACKS ##


  ## INSTANCE METHODS ##


  ## CLASS METHODS ##
  def self.current
    find_or_initialize_by(available_on: Date.today)
  end

  ## PRIVATE METHODS ##
  def assign_time
    [:start_timeselect, :end_timeselect].each do |timeselect|
      self.write_attribute(timeselect.gsub("select"), Time.parse(available_on.to_s + timeselect))
    end
    return true
  end

end
