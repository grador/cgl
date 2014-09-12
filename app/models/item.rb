class Item < ActiveRecord::Base
  validates :name, :full, :art, :box, :presence => true
  validates :box, numericality: { greather_than: 0 }

  has_many :lots, dependent: :destroy
  has_many :loadups, dependent: :destroy
  has_many :orders, through: :lots
  accepts_nested_attributes_for :lots, allow_destroy: true
  accepts_nested_attributes_for :loadups, allow_destroy: true

  # Модуль геттеров, сеттеров и интерпретаторов данных для некоторых классов
  include MakeStringItemUser

  # Getter - Проверка статуса элемента класса на доступность.
  # Во всех клаcсах своя. Используется в МакеString и в классе
  def is_active
    self.num < 100
  end

  def bg_color
    str = self.art[0..2]
    SOME_COLORS[SOME_COLORS.has_key?(str) ? str : 'NON']
  end

  # Setter - смена статуса изделия вместо удаления/возвращения
  def change_status
    self.is_active ? self.num+100 : self.num-100
  end

  def change_obj_status
    self.num = self.change_status
  end

  # Setter - при смене статуса пустой рамки изделия вместо удаления
  def change_status_lot
    self.num < 100 ? 0 : nil
  end

  # Getter - при смене статуса пустой рамки изделия вместо удаления
  def get_status_lot
    self.num < 100 ? nil : 0
  end

  # Изменение статуса изделия при удалении. Его самого и его пустой рамки.
  # Мы его не удаляем, а делаем нелоступным для выбора и наоборот.
  def change_item_status_in_lot
    Lot.where(item_id: self.id, order_id: self.get_status_lot).first.update_attribute(:order_id, self.change_status_lot) && self.update_attribute(:num, self.change_status)
  end

  # Подсчет кол-ва коробок к отгрузке по позициям во всех заказах к отгрузке
  def self.count_items_amount(orders)
    items = self.all
    items.each do |i|
      i.technic = 0
      orders.each { |o| o.lots.each { |l| i.technic += l.quantity if l.item_id == i.id }}
    end
    items.to_a.delete_if{|i| i.technic.zero? }
  end

end
