class Menu < ActiveRecord::Base

  ## CONSTANTS ##
  Operation = {"Open" => 1, "Closed" => 0}

  ## VALIDATIONS ##
  validates :available_on, presence: true, uniqueness: { allow_blank: true }

  ## ASSOCIATIONS ##
  has_many :items_menus
  has_many :main_items_menus, -> {where("items_menus.item_type = ?", 'Main')}, class_name: 'ItemsMenu'
  has_many :side_items_menus, -> {where("items_menus.item_type = ?", 'Side')}, class_name: 'ItemsMenu'
  has_many :items, through: :items_menus

  accepts_nested_attributes_for :items_menus, allow_destroy: true
  accepts_nested_attributes_for :main_items_menus, allow_destroy: true,
                                reject_if: proc { |attributes| attributes['item_id'].blank? }
  accepts_nested_attributes_for :side_items_menus, allow_destroy: true,
                                reject_if: proc { |attributes| attributes['item_id'].blank? }

  ## CALLBACKS ##


  ## INSTANCE METHODS ##


  ## CLASS METHODS ##
  def self.current
    find_or_initialize_by(available_on: Date.today)
  end

  ## PRIVATE METHODS ##

end
