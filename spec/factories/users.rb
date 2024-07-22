FactoryBot.define do
  factory :user do
    email     { Faker::Internet.email }
    password      { 'abcxyz' }
    password_confirmation { 'abcxyz' }
  end
end
