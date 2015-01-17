class Report < ActiveRecord::Base
  belongs_to :user
  has_many :slotereports, dependent: :destroy
  has_many :items, through: :slotereports

  accepts_nested_attributes_for :slotereports, allow_destroy: true

  # не сохраняет пустые строки заказов
  accepts_nested_attributes_for :slotereports, reject_if: proc {
      |attributes| attributes['quantity'].blank? || attributes['quantity']=='0'|| attributes['quantity']==0}

end
