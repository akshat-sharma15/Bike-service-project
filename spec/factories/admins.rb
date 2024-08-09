# spec/factories/admins.rb
FactoryBot.define do
  factory :admin, class: 'Admin' do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { "password123" }
    password_confirmation { "password123" }
    role { 1 }
  end
end
