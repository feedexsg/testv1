class Credit < ActiveRecord::Base

  ## CONSTANTS ##
  Sources = {:admin => "Admin", :direct => "Direct"}

  scope :manual, -> {where(source: Sources[:admin])}

  ## VALIDATIONS ##
  validates :source, :amount, :user, presence: true
  validates :source, inclusion: {in: Sources.values, allow_blank: true}
  validates :amount, numericality: true

  ## ASSOCIATIONS ##
  belongs_to :user

  ## CALLBACKS ##
  after_create :update_user_credits

  ## INSTANCE METHODS ##


  ## CLASS METHODS ##


  ## PRIVATE METHODS ##
  private

  def update_user_credits
    user.update_attribute(:total_credits, user.credits.collect(&:amount).sum)
  end

end
