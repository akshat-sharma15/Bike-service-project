every :day, at: '11:59 pm' do
  runner "DailyRevenueMailer.send_daily_revenue_report"
end

every :day, at: '03:10 am' do
  runner "UserMailer,bill_mail"
end
