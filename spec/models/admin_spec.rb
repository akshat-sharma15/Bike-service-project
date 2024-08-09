# spec/models/admin_spec.rb
require 'rails_helper'

RSpec.describe Admin, type: :model do
  it "is valid with valid attributes" do
    admin = FactoryBot.build(:admin)
    expect(admin).to be_valid
  end

  it "is not valid without a password" do
    admin = FactoryBot.build(:admin, password: nil)
    expect(admin).not_to be_valid
  end

  it "is not valid without a name" do
    admin = FactoryBot.build(:admin, name: nil)
    expect(admin).not_to be_valid
  end

  it "is not valid without a name" do
    admin = FactoryBot.build(:admin, email: nil)
    expect(admin).not_to be_valid
  end

  describe 'scopes' do
    before do
      # Creating users with different roles
      FactoryBot.create(:admin, name: 'Admin User', role: 1)
      FactoryBot.create(:user, name: 'Regular User', role: 0)
    end

    it 'includes users with role 1 in admin_users scope' do
      expect(Admin.admin_users.count).to eq(1)
      expect(Admin.admin_users.first.name).to eq('Admin User')
    end
  end
end
