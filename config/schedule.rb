set :output, './log/cron.log'
set :environment, 'production'

every :day, at: '11:59 pm' do
  runner "DailyRevenueMailer.send_daily_revenue_report"
end

every :day, at: '4:36 pm' do
  runner "UserMailer.bill_mail(User.first)"
end
