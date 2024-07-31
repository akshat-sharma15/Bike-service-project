# class MarkBikesAvailableWorker
#   include Sidekiq::Worker

#   def perform
#     bikes_to_mark_available = Bike.where('return_date <= ?', Date.today - 1).where(status: 'returned')

#     bikes_to_mark_available.each do |bike|
#       bike.avail!
#     end
#   end
# end
