require 'rails_helper'

RSpec.describe ServiceOwner, type: :model do
  it 'is vaild with vaild attributes' do
    service_owner = FactoryBot.build(:service_owner)
    expect(service_owner).to be_valid
  end

  it 'is vaild with without name' do
    service_owner = FactoryBot.build(:service_owner, name: nil)
    expect(service_owner).not_to be_valid
  end

  it 'is vaild with without name' do
    service_owner = FactoryBot.build(:service_owner, password: nil)
    expect(service_owner).not_to be_valid
  end

  it 'is vaild with without name' do
    service_owner = FactoryBot.build(:service_owner, email: nil)
    expect(service_owner).not_to be_valid
  end

  context 'scopes' do
    before do
      FactoryBot.create(:service_owner, name: 'Service Owner', role: 2)
      FactoryBot.create(:admin, name: 'Admin User', role: 1)
    end

    it 'includes users with role 1 in admin_users scope' do
      expect(ServiceOwner.owner.count).to eq(1)
      expect(ServiceOwner.owner.first.name).to eq('Service Owner')
    end
  end
end
