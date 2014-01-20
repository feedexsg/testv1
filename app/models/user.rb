class User < ActiveRecord::Base

  include ActiveModel::SecurePassword
  has_secure_password
  attr_accessor :location_name

  ## CONSTANTS ##


  ## VALIDATIONS ##
  validates :name, :email, :password_digest, presence: true
  validates :email, uniqueness: { allow_blank: true }
  validates :email, format: { with: /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/, allow_blank: true }
  validates :mobile, format: { with: /\A[8-9]\d{7}\z/, allow_blank: true }

  ## ASSOCIATIONS ##
  belongs_to :location

  ## CALLBACKS ##
  before_validation :assign_location

  ## INSTANCE METHODS ##


  ## CLASS METHODS ##


  ## PRIVATE METHODS ##
  def assign_location
    if location_name.present?
      self.location = Location.find_or_create_by_name(location_name)
      if location.new_record?
        errors.add(:location_name, "can't be blank")
      end
    end
  end

end
