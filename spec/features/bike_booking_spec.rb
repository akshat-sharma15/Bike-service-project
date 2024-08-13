require 'rails_helper'

RSpec.feature "Bike Boking Management", type: :feature do
  let(:service_owner) { create(:service_owner) }
  let(:service_center) { create(:service_center, service_owner: service_owner) }
  let(:client_user) { create(:client_user) }
  let(:bike) { create(:bike, service_center: service_center) }

  describe "User books a bike" do
    let(:user) { User.find_by(id: client_user.id) }
    before do
      sign_in user
    end

    it 'when user books with vaild date' do
      visit service_owner_service_center_bike_path(service_owner, service_center, bike)

      click_button 'Book Now'
      fill_in 'Booking Date', with: Date.today
      fill_in 'Return Date', with: Date.today.to_s
      click_button 'Create Booking'

      expect(Booking.count).to eq(1)
      expect(Booking.last.status).to eq('pending') # Assuming only one slot booking is allowed
    end

    it 'when user books with past booking date' do
      visit service_owner_service_center_bike_path(service_owner, service_center, bike)

      click_button 'Book Now'
      fill_in 'Booking Date', with: Date.yesterday
      fill_in 'Return Date', with: Date.today
      click_button 'Create Booking'

      expect(page).to have_content("Booking date can't be in the past")
    end

    it 'when user books with past return date less than booking date date' do
      visit service_owner_service_center_bike_path(service_owner, service_center, bike)

      click_button 'Book Now'
      fill_in 'Booking Date', with: Date.today + 2.days
      fill_in 'Return Date', with: Date.today
      click_button 'Create Booking'

      expect(page).to have_content("must be after the booking date")
    end
  end

  describe "Owner Deals with bike" do
    let(:booking) { create(:booking, service_center: service_center, client_user: client_user, bike: bike, booking_date: Date.today, return_date: Date.tomorrow)}
    let(:user) { User.find_by(id: service_owner.id) }
    before do
      sign_in user
    end

    it 'Owner confirms booking' do
      visit service_owner_service_center_bike_booking_path(service_owner, service_center, bike, booking)
      click_button 'Confirm'

      expect(booking.reload.status).to eq('confirmed')
    end

    it 'Owner activates booking from comfirmed' do
      booking.update(status: 'confirmed')
      visit service_owner_service_center_bike_booking_path(service_owner, service_center, bike, booking)
      click_button 'Activate'

      expect(booking.reload.status).to eq('active')
      expect(booking.bike.reload.status).to eq('on_rent')
    end

    it 'Owner complete booking' do
      booking.update(status: 'active')
      visit service_owner_service_center_bike_booking_path(service_owner, service_center, bike, booking)
      click_button 'Complete'

      expect(booking.reload.status).to eq('completed')
    end

    it 'Owner rejects booking' do
      booking.update(status: 'confirmed')
      visit service_owner_service_center_bike_booking_path(service_owner, service_center, bike, booking)
      click_button 'Reject'

      expect(booking.reload.status).to eq('rejected')
    end
  end
end
