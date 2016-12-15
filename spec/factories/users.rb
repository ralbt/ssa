FactoryGirl.define do
  factory :user do
    name 'Joe'
    sequence(:email) { |n| "user#{n}@example.com" }
    status User.statuses[:created]
  end
end
