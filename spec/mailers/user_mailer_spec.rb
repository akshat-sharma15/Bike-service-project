require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  let(:service_owner) { create(:service_owner, email: 'owner@example.com') }
  let(:service_center) { create(:service_center, service_owner: service_owner) }
  let(:client_user) { create(:client_user, email: 'client@example.com') }
  let(:bike) { create(:bike, service_center: service_center) }
  let(:booking) { create(:booking, bike: bike, client_user: client_user, status: 'active') }

  describe '#bill_mail' do
    let(:mail) { UserMailer.bill_mail(client_user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Congrats your service done')
      expect(mail.to).to eq([client_user.email])
      expect(mail.from).to eq(['notifications@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to include('hello your bike has done with service please collect it')
      expect(mail.body.encoded).to include('this is your bill')
    end
  end

  describe '#reject_mail' do
    let(:mail) { UserMailer.reject_mail(client_user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Rejection Mail')
      expect(mail.to).to eq([client_user.email])
      expect(mail.from).to eq(['notifications@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match(/We regret to inform you/)
      expect(mail.body.encoded).to match(/Your Slot was rejected/)
    end
  end

  describe '#daily_revenue_report' do
    let(:mail) { UserMailer.daily_revenue_report(service_center) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Daily report Mail')
      expect(mail.to).to eq([service_owner.email])
      expect(mail.from).to eq(['notifications@example.com'])
    end

    it 'renders the body' do
      parsed_body = Capybara.string(mail.body.encoded)
      expect(parsed_body).to have_content('Daily Revenue Report')
    end
  end
end
