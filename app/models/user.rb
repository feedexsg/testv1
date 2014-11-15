class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  paginates_per 10

  before_create :create_remember_token
  before_create :generate_confirmation_token
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
  validates :name, :presence => true
  validates_presence_of :password, :on => :create
  validates :password, :confirmation => true, :on => :create
  validates :password, :length => {:minimum => 6 }, :on => :create
  validates :password, :length => {:minimum => 6 }, :confirmation => true, :allow_blank => true, :on => :update

  validates :email, uniqueness: { allow_blank: false }, :presence => true
  validates :email, :email => true
  validates :mobile, format: { with: /\A[8-9]\d{7}\z/, allow_blank: false },:presence => true, :on => :create
  validates :mobile, format: { with: /\A[8-9]\d{7}\z/, allow_blank: true }, :on => :update

  ## ASSOCIATIONS ##
  has_many :credits, dependent: :destroy
  has_many :orders, dependent: :destroy
  accepts_nested_attributes_for :credits

  ## CALLBACKS ##
  #after_create :send_welcome_notification

  def send_beta_mailer
    # Create reset token
    self.reset_password_token = loop do
      token = SecureRandom.urlsafe_base64(nil, false)
      break token unless User.exists?(reset_password_token: token)
    end
    self.reset_password_sent_at = Time.zone.now
    save!

    # Send email confirmation
    OrderMailer.send_beta_welcome_email(self).deliver
  end

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

  def send_password_reset
    self.reset_password_token = loop do
      token = SecureRandom.urlsafe_base64(nil, false)
      break token unless User.exists?(reset_password_token: token)
    end
    self.reset_password_sent_at = Time.zone.now
    save!
    OrderMailer.send_password_reset_email(self).deliver
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

  protected
  def generate_confirmation_token
    self.confirmation_token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless User.exists?(confirmation_token: random_token)
    end
  end

end
