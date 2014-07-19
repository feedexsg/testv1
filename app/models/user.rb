class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  before_create :create_remember_token
  before_save { self.email = email.downcase }

  include ActiveModel::SecurePassword
  has_secure_password

  belongs_to :colony

  ## CONSTANTS ##

  ## VALIDATIONS ##
  #validates :name, :email, :password_digest, presence: true
  #validates :email, uniqueness: { allow_blank: true }
  #validates :email, format: { with: /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/, allow_blank: true }
  #validates :mobile, format: { with: /\A[8-9]\d{7}\z/, allow_blank: true }

  ## ASSOCIATIONS ##
  has_many :credits, dependent: :destroy
  has_many :orders, dependent: :destroy
  accepts_nested_attributes_for :credits

  ## CALLBACKS ##
  #after_create :send_welcome_notification

  ## INSTANCE METHODS ##
  def available_credits
    credits.collect(&:amount).sum - orders.collect(&:amount).sum
  end

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  ## CLASS METHODS ##


  ## PRIVATE METHODS ##
  private

  def create_remember_token
    self.remember_token = User.digest(User.new_remember_token)
  end

  def send_welcome_notification
    Notifier.welcome_notification(self)
  end

end
