class Credit < ActiveRecord::Base

  paginates_per 10

  ## CONSTANTS ##
  Sources = {:admin => "Admin", :direct => "Direct"}

  scope :manual, -> {where(source: Sources[:admin])}
  scope :direct, -> {where(source: Sources[:direct])}

  ## VALIDATIONS ##
  validates :source, :amount, :user, presence: true
  validates :source, inclusion: {in: Sources.values, allow_blank: true}
  validates :amount, numericality: true

  ## ASSOCIATIONS ##
  belongs_to :user

  ## CALLBACKS ##
  after_create :update_user_credits
  after_create :send_credit_notification

  ## INSTANCE METHODS ##


  ## CLASS METHODS ##


  ## PRIVATE METHODS ##
  private

  def update_user_credits
    user.update_attribute(:total_credits, user.available_credits)
  end

  def send_credit_notification
    Notifier.credit_notification(user, self)
  end

end
