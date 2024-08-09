FactoryBot.define do
  factory :service_owner, class: 'ServiceOwner' do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { "654321" }
    password_confirmation { "654321" }
    role { 2 }
  end
end
