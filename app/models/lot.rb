class Lot < ActiveRecord::Base


  belongs_to :item
  accepts_nested_attributes_for :item
  belongs_to :order, autosave: true

  # Сортировка слотов заказа по имени изделия
  scope :ordered_item_name, -> { includes(:item).sort_by {|l|l.item.name} }

  # Для редактирования заказа добавляем в список отсутствующие в заказе изделия
  def self.modify_list(list)
    (list + self.get_full_list).uniq(&:item_id)
  end

  # в случае успеха возвращает полный список открытых для использования изделий
  def self.get_full_list
    where(order_id: nil).includes(:item).sort_by {|l|l.item.name}
  rescue
    return nil
  end

  # возвращает список изделий подготовленный для данного клиента
  # поднимает в начало списка изделия из его последнего заказа
  # если нет истории возвращает просто список. Нет списка - прерывает операцию
  def self.prepare_list
    begin
      full_list = self.get_full_list
      last_numbers_list = current_user.orders.last.lots.map(&:item_id)
      (full_list.select{ |l| last_numbers_list.include?(l.item_id)} + full_list).uniq(&:item_id)
    rescue
      return full_list
    end
  end

end