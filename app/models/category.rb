class Category < ActiveRecord::Base

  ## CONSTANTS ##
  @@main_id = @@side_id = nil

  ## VALIDATIONS ##
  validates :name, presence: true
  
  ## ASSOCIATIONS ##
  has_many :items

  ## CALLBACKS ##


  ## INSTANCE METHODS ##


  ## CLASS METHODS ##
  class << self
    ["main_id" ,"side_id"].each do |str|
      define_method str do
        #return class_variable_get("@@#{str}") unless class_variable_get("@@#{str}").nil?
        class_variable_set("@@#{str}", (Category.where(name: str.gsub("_id", '')).first.id rescue nil))
      end
    end
  end

end
