class Order < ActiveRecord::Base

  ## CONSTANTS ##
  scope :today, where("created_at > date(?)", Date.today)

  ## VALIDATIONS ##
  validates :user, :amount, presence: true

  ## ASSOCIATIONS ##
  belongs_to :user

  ## CALLBACKS ##
  after_create :send_order_notification

  ## INSTANCE METHODS ##
  def description
  end

  ## CLASS METHODS ##


  ## PRIVATE METHODS ##
  private

  def send_order_notification
    Notifier.order_notification(user)
  end

end
