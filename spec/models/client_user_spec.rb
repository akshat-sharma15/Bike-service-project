require 'rails_helper'

RSpec.describe ClientUser, type: :model do
  it 'is vaild with vaild attributes' do
    client_user = FactoryBot.build(:client_user)
    expect(client_user).to be_valid
  end

  it 'is vaild with without name' do
    client_user = FactoryBot.build(:client_user, name: nil)
    expect(client_user).not_to be_valid
  end

  it 'is vaild with without name' do
    client_user = FactoryBot.build(:client_user, password: nil)
    expect(client_user).not_to be_valid
  end

  it 'is vaild with without name' do
    client_user = FactoryBot.build(:client_user, email: nil)
    expect(client_user).not_to be_valid
  end

  context 'scopes' do
    before do
      FactoryBot.create(:client_user, name: 'Client', role: 0)
      FactoryBot.create(:admin, name: 'Admin User', role: 1)
    end

    it 'includes users with role 1 in admin_users scope' do
      expect(ClientUser.user_client.count).to eq(1)
      expect(ClientUser.user_client.first.name).to eq('Client')
    end
  end
end
