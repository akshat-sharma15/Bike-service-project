require 'rails_helper'

RSpec.describe RatingsController, type: :controller do
  include Devise::Test::ControllerHelpers
  let(:client_user) { FactoryBot.create(:client_user) }
  let(:service_owner) { FactoryBot.create(:service_owner) }
  let(:service_center) { FactoryBot.create(:service_center, service_owner: service_owner) }
  let(:rating) { FactoryBot.create(:rating, service_center: service_center, client_user: client_user) }
  let(:user) { User.find_by(id: client_user.id) }

  before do
    sign_in user
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new rating' do
        expect {
          post :create, params: {
            service_owner_id: service_owner.id,
            service_center_id: service_center.id,
            rating: { star: 5, comments: 'Great service!' }
          }
        }.to change(Rating, :count).by(1)

        expect(response).to redirect_to(service_owner_service_center_path(service_owner, service_center))
        expect(flash[:notice]).to eq('Rating was successfully added.')
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new rating' do
        expect {
          post :create, params: {
            service_owner_id: service_owner.id,
            service_center_id: service_center.id,
            rating: { star: nil, comments: '' }
          }
        }.not_to change(Rating, :count)

        expect(response).to redirect_to(service_owner_service_center_path(service_owner, service_center))
      end
    end
  end
end
