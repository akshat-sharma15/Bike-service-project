FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email     { Faker::Internet.email }
    password      { 'abcxyz' }
    password_confirmation { 'abcxyz' }
  end
end
