FactoryBot.define do
  factory :client_user, class: 'ClientUser' do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { "password123" }
    password_confirmation { "password123" }
    role { 0 }
  end
end
