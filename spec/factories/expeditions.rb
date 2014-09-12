# This will guess the Expedition class

FactoryGirl.define do

  factory :expedition do
    sequence(:user_id) { |n| n}
    sequence(:take_aboard) { |n| Date.today }
    delivered Date.today
    updated_at Date.today
  end

  factory :only_expedition, class: Expedition do
    sequence(:user_id) { |n| n }
    sequence(:take_aboard) { Date.today }
    delivered Date.today
    updated_at Date.today
  end

end

