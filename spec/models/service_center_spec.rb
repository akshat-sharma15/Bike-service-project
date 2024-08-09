require 'rails_helper'

RSpec.describe ServiceCenter, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      service_center = FactoryBot.build(:service_center)
      expect(service_center).to be_valid
    end

    it 'is not valid without a name' do
      service_center = FactoryBot.build(:service_center, name: nil)
      expect(service_center).not_to be_valid
    end

    it 'is not valid without a location' do
      service_center = FactoryBot.build(:service_center, location: nil)
      expect(service_center).not_to be_valid
    end
  end

  describe 'associations' do
    it { should belong_to(:service_owner).class_name('ServiceOwner').inverse_of(:service_centers) }
  end
end
