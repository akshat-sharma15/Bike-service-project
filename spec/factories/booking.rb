FactoryBot.define do
  factory :booking do
    booking_date { Date.today }
    return_date { Date.tomorrow }
    association :service_center
    association :client_user
    association :bike
  end
end
