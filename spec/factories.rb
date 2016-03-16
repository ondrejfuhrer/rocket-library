FactoryGirl.define do
  factory :user do
    first_name { FFaker::Name.first_name }
    last_name { FFaker::Name.last_name }
    email { FFaker::Internet.email }
    password 'testtest123'
  end

  factory :book do
    name { FFaker::Lorem.words(3).join(' ') }
    author { FFaker::Name.name }
    isbn { [*1000000..9999999].sample }
  end
end
