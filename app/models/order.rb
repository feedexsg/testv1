class Order < ActiveRecord::Base

  ## CONSTANTS ##
  scope :today, -> {where("created_at > date(?)", Date.today)}
  serialize :items, Array

  ## VALIDATIONS ##
  validates :user, :amount, :items, presence: true

  ## ASSOCIATIONS ##
  belongs_to :user

  ## CALLBACKS ##
  after_create :send_order_notification
  after_create :deduct_credits

  ## INSTANCE METHODS ##
  def description
    desc = ""
    items.each do |item|
      li = item_list.select{|i| item["id"].to_i == i.id}.first
      desc += "#{li.name}, Qty : #{item['quantity']} <br/>" if li
    end
    desc
  end

  def calculate_amount
    total_amt = 0
    items.each do |i|
      item = Item.find_by_id(i["id"])
      total_amt += (item.price.to_f * i["quantity"].to_i) if item
    end
    self.amount = total_amt
  end

  def item_list
    Item.where(id: items.collect{|i| i["id"]}).all
  end

  ## CLASS METHODS ##


  ## PRIVATE METHODS ##
  private

  def deduct_credits
    user.update_attribute(:total_credits, user.available_credits)
  end

  def send_order_notification
    Notifier.order_notification(user)
  end

end
