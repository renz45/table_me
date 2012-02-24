FactoryGirl.define do
  factory :user do
    sequence(:name) {|n| "name#{n}"}
    sequence(:email) {|n| "name#{n}@email.com"}
  end
end