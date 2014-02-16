module Admin::OrdersHelper

  def location_set
    ["All Locations"] + DeliveryLocation.all.collect{|l| [l.name, l.id]}
  end

end
