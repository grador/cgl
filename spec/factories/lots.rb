FactoryGirl.define do

  factory :lot_item, class: Lot do

    # order_id  nil
    quantity 0
    association :item
  end

  factory :lot, class: Lot do

    quantity 10
    item
    order
  end

end
