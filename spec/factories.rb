FactoryGirl.define do
  sequence(:email) { |n| "foo#{n}@example.com" }
  factory :user do
    email { FactoryGirl.generate :email }
    password 'password123'
  end
end