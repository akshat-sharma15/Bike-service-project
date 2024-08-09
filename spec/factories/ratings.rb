FactoryBot.define do
  factory :rating do
    star { 5 }
    comments { "Excellent service!" }
    association :service_center, factory: :service_ownerc
    association :client_user, factory: :client_user
  end
end
