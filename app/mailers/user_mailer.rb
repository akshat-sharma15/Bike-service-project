class UserMailer < ApplicationMailer
  default from: 'notifications@example.com'
  def bike_on_rent_email(bike)
    @bike = bike
    @clients = @bike.bookings.where(status: 'active').client_users

    @clients.each do |client|
      mail(to: client.email, subject: 'Your Bike is Currently on Rent')
    end
  end

  def bill_mail(user)
    mail(to: user.email, subject: 'Congrats your service done')
  end

  def reject_mail(user)
    mail(to: user.email, subject: 'Rejection Mail')
  end

  def daily_revenue_report(service_center)
    @service_center = service_center
    mail(to: @service_center.service_owner.email, subject: 'Daily report Mail')
  end
end
