class DailyBikeRentEmailSenderWorker < ApplicationJob
  queue_as :default

  def perform
    slots = Slot.where(status: :completed, booking_date: Date.today)

    slots.each do |slot|
      UserMailer.bill_mail(slot.client_user).deliver_now
    end
  end
end
