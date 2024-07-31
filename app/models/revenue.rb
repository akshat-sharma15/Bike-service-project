class Revenue < ApplicationRecord
  belongs_to :service_center
  validates :date, presence: true

  scope :date_revenue, ->(date, id) { where(date: date, service_center_id: id) }

  def self.total_revenue_for_month(year, month, id)
    start_date = Date.new(year, month, 1)
    end_date = start_date.end_of_month
    end_date = Date.today if end_date > Date.today

    where(date: start_date..end_date, service_center_id: id).sum(:revenue)
  end

  def self.total_revenue_for_date(date, id)
    where(date: date, service_center_id: id).sum(:revenue)
  end
end
