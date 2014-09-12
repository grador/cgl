# This will guess the User class

FactoryGirl.define do

  factory :item do
    sequence(:name) { |n| "Короткое название #{n}" }
    sequence(:full) { |n| "Полное название #{n}" }
    sequence(:art) { |n| "ORA-P-100-0#{n}" }
    box   15
    num   10
  end
  factory :item_lot, class: Item do
    sequence(:name) { |n| "Короткое название #{n}" }
    sequence(:full) { |n| "Полное название #{n}" }
    sequence(:art) { |n| "ORA-P-100-0#{n}" }
    box   15
    num   10
    after(:create) do |i|
      create(:lot_item, item: i)
    end
  end

end
