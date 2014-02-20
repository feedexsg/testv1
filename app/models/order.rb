class Order < ActiveRecord::Base

  ## CONSTANTS ##
  scope :today, where("created_at > date(?)", Date.today)

  ## VALIDATIONS ##
  validates :user, :amount, presence: true

  ## ASSOCIATIONS ##
  belongs_to :user

  ## CALLBACKS ##
  after_create :send_order_notification
  after_create :deduct_credits

  ## INSTANCE METHODS ##
  def description
  end

  ## CLASS METHODS ##


  ## PRIVATE METHODS ##
  private

  def deduct_credits
    user.update_attribute(total_credits: user.available_credits)
  end

  def send_order_notification
    Notifier.order_notification(user)
  end

end
