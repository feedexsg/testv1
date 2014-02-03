class Menu < ActiveRecord::Base

  ## CONSTANTS ##
  attr_accessor :start_timeselect, :end_timeselect
  Operation = {"Open" => 1, "Closed" => 0}

  ## VALIDATIONS ##
  validates :available_on, presence: true, uniqueness: { allow_blank: true }
  validate :assign_time

  ## ASSOCIATIONS ##
  has_many :items_menus
  has_many :main_items_menus, -> {where("items_menus.item_type = ?", 'Main')}, class_name: 'ItemsMenu'
  has_many :side_items_menus, -> {where("items_menus.item_type = ?", 'Side')}, class_name: 'ItemsMenu'
  has_many :items, through: :items_menus

  accepts_nested_attributes_for :items_menus, allow_destroy: true
  accepts_nested_attributes_for :main_items_menus, allow_destroy: true
  accepts_nested_attributes_for :side_items_menus, allow_destroy: true

  ## CALLBACKS ##


  ## INSTANCE METHODS ##


  ## CLASS METHODS ##
  def self.current
    find_or_initialize_by(available_on: Date.today)
  end

  ## PRIVATE METHODS ##
  def assign_time
    self.start_time = Time.parse(available_on.to_s + " " + self.start_timeselect)
    self.end_time = Time.parse(available_on.to_s + " " + self.end_timeselect)
    return true
  end

end
