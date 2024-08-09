require 'rails_helper'

RSpec.describe Slot, type: :model do
  before do
    FactoryBot.create(:slot, booking_date: Date.today)
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      slot = FactoryBot.build(:slot)
      expect(slot).to be_valid
    end

    it 'is not valid without a booking date' do
      slot = FactoryBot.build(:slot, booking_date: nil)
      expect(slot).not_to be_valid
      expect(slot.errors[:booking_date]).to include("can't be blank")
    end

    it 'is not valid with a past booking date' do
      slot = FactoryBot.build(:slot, booking_date: Date.yesterday)
      slot.valid?
      expect(slot.errors[:booking_date]).to include("can't be in the past")
    end
  end

  describe 'associations' do
    it { should belong_to(:service_center).class_name('ServiceCenter') }
    it { should belong_to(:client_user).inverse_of(:slots) }
  end

  describe 'scopes' do
    let!(:slot1) { FactoryBot.create(:slot, booking_date: Date.today, status: :confirmed) }
    let!(:slot2) { FactoryBot.create(:slot, booking_date: Date.today, status: :on_service) }

    it 'returns slots with booking_date and on_service status' do
      expect(Slot.working(Date.today)).to include(slot2)
      expect(Slot.with_booking_date(Date.today)).not_to include(slot2)
    end
  end
end
