class Order < ActiveRecord::Base

  validates :deliver_at, presence: true, on: :create

  belongs_to :user
  has_many :lots, dependent: :destroy
  has_many :items, through: :lots

  accepts_nested_attributes_for :lots, allow_destroy: true

  # не сохраняет пустые строки заказов
  accepts_nested_attributes_for :lots, reject_if: proc {
      |attributes| attributes['quantity'].blank? || attributes['quantity']=='0'|| attributes['quantity']==0}

  # Модуль интерпретаторов данных для некоторых классов
  include MakeStringOrderExpedition
  include MakeString
  include SomeClassMethod

  # Getter - Проверка статуса элемента класса.
  # Во всех клаcсах своя. Используется в МакеString и в классе
  def is_active
    !self.delivered
  end

  def change_status
    self.is_active ? Date.today : nil
  end

  def change_obj_status
    self.delivered = self.change_status
  end

  def order_delivered?
    !self.delivered.nil? || (self.deliver_at - 1.day).past?
  end

end
