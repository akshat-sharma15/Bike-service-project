FactoryBot.define do
  factory :service_center do
    name { Faker::Company.name }
    location { Faker::Address.city }
    total_slots { 10 }
    association :service_owner, factory: :service_owner
  end
end
