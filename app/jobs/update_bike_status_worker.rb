# class UpdateBikeStatusWorker
#   include Sidekiq::Worker

#   def perform
#     Booking.where(booking_date: Date.today).find_each do |booking|
#       booking.bike.update(status: 'on_rent')
#     end
#   end
# end
