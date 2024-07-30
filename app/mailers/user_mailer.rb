class UserMailer < ApplicationMailer
  default from: 'notifications@example.com'
  def bike_on_rent_email(bike)
    @bike = bike
    @client = @bike.bookings.where(status: 'active').client_user

    mail(to: @client.email, subject: 'Your Bike is Currently on Rent')
  end

  def bill_mail(user)
    mail(to: user.email, subject: 'Congrats your service done')
  end

  def reject_mail(user)
    mail(to: user.email, subject: 'Rejection Mail')
  end
end
