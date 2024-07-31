class RevenueUpdate
  attr_reader :service_center, :slot, :bike

  delegate :cost, to: :slot, prefix: true
  delegate :booking, to: :bike

  def initialize(service_center:, slot: nil, bike: nil)
    @service_center = service_center
    @slot = slot
    @bike = bike
  end


  def update_revenue
    revenue = service_center.revenues.find_by(date: Date.today)
    revenue ||= service_center.revenues.new(date: Date.today)
    set_revenue_amount(revenue: revenue, amount: slot_cost.to_f)
    revenue.save
  end

  def update_rev_bike
    revenue = service_center.revenues.find_by(date: Date.today)
    revenue ||= service_center.revenues.new(date: Date.today)
    set_revenue_amount(revenue: revenue, amount: booking.cost.to_f)
    revenue.save
  end

  def set_revenue_amount(revenue:, amount:)
    revenue.assign_attributes(revenue: revenue.revenue.to_f + amount)
  end
end
