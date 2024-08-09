FactoryBot.define do
  factory :slot do
    booking_date { Faker::Date.forward(days: 23) }
    service_type { [:full_service, :engine_service, :wash_service].sample }
    association :service_center
    association :client_user

    after(:build) do |slot|
      slot.service_center ||= FactoryBot.create(:service_center)
      slot.client_user ||= FactoryBot.create(:client_user)
    end
  end
end
