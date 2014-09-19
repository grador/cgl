class Message < ActiveRecord::Base
  has_many :sendmen, dependent: :destroy
  has_one :user, through: :sendmen
  accepts_nested_attributes_for :sendmen, allow_destroy: true

end
