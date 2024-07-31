class DailyRevenueReport < ApplicationJob
  queue_as :default

  def perform
    ServiceCenter.all.each do |service_center|
      UserMailer.daily_revenue_report(service_center).deliver_now
    end
  end
end
