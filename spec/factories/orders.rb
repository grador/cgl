# This will guess the Order class

FactoryGirl.define do

  factory :order do
    sequence(:user_id) { |n| n }
    sequence(:deliver_at) {Date.today}

    factory :order_lot, class: Order do
      transient do
        lots_count 3
      end

      after(:create) do |order, evaluator|
        create_list(:lot, evaluator.lots_count, order: order)
      end
    end
  end
  factory :only_order, class: Order do
    sequence(:user_id) { |n| n }
    sequence(:deliver_at) {Date.tomorrow}
  end
end

