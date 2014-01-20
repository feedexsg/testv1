class User < ActiveRecord::Base

  include ActiveModel::SecurePassword
  has_secure_password

  ## CONSTANTS ##


  ## VALIDATIONS ##
  validates :name, :email, :password_digest, presence: true
  validates :email, uniqueness: { allow_blank: true }
  validates :email, format: { with: /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/, allow_blank: true }
  validates :mobile, format: { with: /\A[8-9]\d{7}\z/, allow_blank: true }

  ## ASSOCIATIONS ##

  ## CALLBACKS ##

  ## INSTANCE METHODS ##


  ## CLASS METHODS ##


  ## PRIVATE METHODS ##

end
