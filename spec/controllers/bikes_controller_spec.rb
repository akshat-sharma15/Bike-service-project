require 'rails_helper'

RSpec.describe BikesController, type: :controller do
  let(:service_owner) { create(:service_owner) }
  let(:service_center) { create(:service_center, service_owner: service_owner) }
  let(:bike) { create(:bike, service_center: service_center) }

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new bike and redirects' do
        expect {
          post :create, params: { service_owner_id: service_owner.id, service_center_id: service_center.id, bike: {  info: 'TVS Jupiter 110',  regstration_num: "MP 09 BW 7865",  rate: 100 } }
        }.to change(Bike, :count).by(1)

        expect(flash[:notice]).to eq('bike was successfully added.')
        expect(response).to redirect_to(service_owner_service_center_path(service_owner, service_center))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new bike and redirects' do
        expect {
          post :create, params: { service_owner_id: service_owner.id, service_center_id: service_center.id, bike: { info: 'TVS Jupiter 110' } }
        }.to change(Bike, :count).by(0)

        expect(flash[:notice]).to eq('bike not added some thing went wroung.')
        expect(response).to redirect_to(service_owner_service_center_path(service_owner, service_center))
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid parameters' do
      it 'updates the bike and redirects' do
        patch :update, params: { service_owner_id: service_owner.id, service_center_id: service_center.id, id: bike.id, bike: { info: 'Updated Info' } }
        bike.reload

        expect(bike.info).to eq('Updated Info')
        expect(flash[:notice]).to eq('Data updated successfully.')
        expect(response).to redirect_to(service_owner_service_center_path(service_owner, service_center))
      end
    end

    context 'with invalid parameters' do
      it 'does not update the bike and redirects' do
        patch :update, params: { service_owner_id: service_owner.id, service_center_id: service_center.id, id: bike.id, bike: { info: '' } }
        bike.reload

        expect(bike.info).not_to eq('')
        expect(flash[:notice]).to eq('Bike not updated.')
        expect(response).to redirect_to(service_owner_service_center_path(service_owner, service_center))
      end
    end
  end
end
