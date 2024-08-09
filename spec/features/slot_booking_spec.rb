require 'rails_helper'

RSpec.feature "Slot Management", type: :feature do
  let(:service_owner) { create(:service_owner) }
  let(:service_center) { create(:service_center, service_owner: service_owner, total_slots: 5) }
  let(:client_user) { create(:client_user) }

  describe "User books a slot" do
    let(:user) { User.find_by(id: client_user.id) }
    before do
      sign_in user
    end

    it 'when all slots are empty, it should confirm the booking' do
      visit service_owner_service_center_path(service_owner, service_center)

      click_button 'Add Slot'
      fill_in 'Booking Date', with: Date.today.to_s
      select 'Full Service', from: 'Service Type'
      fill_in 'Time', with: '10:00'
      click_button 'Create Slot'

      # expect(flash[:notice]).to eq('Slot was successfully created. its under rewiew Check status after some time for updates')
      expect(Slot.count).to eq(1)
      expect(Slot.last.status).to eq('confirmed') # Assuming only one slot booking is allowed
    end

    it 'when all slots are booked, it should waiting' do
      client_users = create_list(:client_user, 5) # Create 5 different client_user instances
      client_users.each do |client_user|
        create(:slot, service_center: service_center, client_user: client_user, booking_date: Date.today)
      end
      visit service_owner_service_center_path(service_owner, service_center)

      click_button 'Add Slot'
      fill_in 'Booking Date', with: Date.today.to_s
      select 'Full Service', from: 'Service Type'
      fill_in 'Time', with: '10:00'
      click_button 'Create Slot'
      expect(Slot.count).to eq(6)
      expect(Slot.last.status).to eq('waiting')
    end

    it 'when user try to book slot within 3 months, it should rejected' do
      create_list(:slot, 3, service_center: service_center, client_user: client_user, booking_date: Date.today)

      visit service_owner_service_center_path(service_owner, service_center)
      click_button 'Add Slot'
      fill_in 'Booking Date', with: Date.today.to_s
      select 'Full Service', from: 'Service Type'
      fill_in 'Time', with: '10:00'
      click_button 'Create Slot'
      expect(Slot.count).to eq(4)
      expect(Slot.last.status).to eq('rejected')
    end
    context 'owner deals with slot' do
      let(:slot) { create(:slot, service_center: service_center, client_user: client_user, booking_date: Date.today,status: "pending") }
      let(:user) { User.find_by(id: service_owner.id) }
      before do
        sign_in user
      end

      it 'Owner Starts service' do
        visit service_owner_service_center_slot_path(slot.service_center.service_owner, slot.service_center, slot)
        click_button 'Start Service'
        slot.reload
        expect(slot.status).to eq('on_service')
      end

      it 'Owner completes service' do
        slot.update(status: 'on_service')
        visit service_owner_service_center_slot_path(slot.service_center.service_owner, slot.service_center, slot)
        click_button 'Complete'
        expect(slot.reload.status).to eq('completed')
      end

      it 'Owner rejects slot' do
        slot.update(status: 'on_service')
        visit service_owner_service_center_slot_path(slot.service_center.service_owner, slot.service_center, slot)
        click_button 'Reject'
        expect(slot.reload.status).to eq('rejected')
      end
    end
  end
end
