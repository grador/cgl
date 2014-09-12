# This will guess the User class

FactoryGirl.define do

  factory :user do
    sequence(:email) { |n| "person#{n}@example.com" }
    sequence(:name) { |n| "person#{n}" }
    address  'Адрес клиента'
    password 'password'
    type_owner USER
  end

  factory :expeditor, class: User do
    sequence(:email) { |n| "person#{n}@example.com" }
    sequence(:name) { |n| "person#{n}" }
    address  'Адрес клиента'
    password 'password'
    type_owner EXPEDITOR
  end

  factory :tester, class: User do
    sequence(:email) { |n| "person#{n}@example.com" }
    sequence(:name) { |n| "person#{n}" }
    address  'Адрес клиента'
    password 'password'
    type_owner TESTER
  end

  factory :admin, class: User do
    sequence(:email) { |n| "person#{n}@example.com" }
    sequence(:name) { |n| "person#{n}" }
    sequence(:address) { |n| "Адрес клиента#{n}" }
    password 'password'
    type_owner ADMIN
  end

  factory :users, class: User  do
    sequence(:email) { |n| "person#{n}@example.com" }
    sequence(:name) { |n| "person#{n}" }
    sequence(:type_owner) { |n| TYPE_USER[n % 4]}
    address  'Адрес клиента'
    password 'password'
  end


end
