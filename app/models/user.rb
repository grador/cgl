class User < ActiveRecord::Base
  attr_accessor :password

  before_save :encrypt_password

  validates_confirmation_of :password
  validates_presence_of :password
  validates_presence_of :email
  validates_presence_of :name
  validates_presence_of :address
  validates_uniqueness_of :email
  validates_uniqueness_of :name
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, on: :create }

  has_many :orders
  accepts_nested_attributes_for :orders, allow_destroy: true
  accepts_nested_attributes_for :orders, update_only: true
  has_many :expeditions
  accepts_nested_attributes_for :expeditions, allow_destroy: true
  has_many :loadups
  accepts_nested_attributes_for :loadups, reject_if: lambda {
      |attributes| attributes['quantity'].blank? || attributes['quantity'] == '0'|| attributes['quantity'] ==0}

  # Модуль интерпретаторов данных для некоторых классов
  include MakeStringItemUser

  # Без коментариев: http://rubygems.org/gems/bcrypt-ruby
  def self.authenticate(email, password)
    user = find_by_email(email)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end

  # Без коментариев: http://rubygems.org/gems/bcrypt-ruby
  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  # Getter - Проверка статуса элемента класса на доступность.
  # Во всех клаcсах своя. Используется в МакеString и в классе
  def is_active
    self.region < 100
  end

  # Проверка пользователя на права
  def is_(type = nil)
    self.type_owner == type
  end

  # Setter - при смене статуса пользователя вместо удаления
  def change_status
    self.is_active ? self.region+100 : self.region-100
  end

  def change_obj_status
    self.region = self.change_status
  end

  # готовит список id всех пользователей
  def self.all_users_id
    all.map(&:id)
  end

  # Отправка по почте пакета документов на отгрузку
  # адресат - self, аргументы:
  # waybill - накладная на получение со склада партии,
  # orders - накладные получателям
  # возвращает true/false - успех/неудача
  def email_shipping_docs(waybill, orders)
    return false unless Cglmailer.docs_email(waybill, self)
    orders.each { |o| return false unless Cglmailer.docs_email(o,self) }
    true
  end

  # готовит список
  # date_delivered - дата доставки, nil - недоставлен.
  # plane_date - планируемая дата
  # self - экспедитор
  def take_orders_delivered(date_delivered, plane_date)
    Order.where(region: self.region, deliver_at: (plane_date - 7.day)..plane_date, delivered: date_delivered)
  end

  # маркирует список заказов, как доставленные
  # date_delivered - фактическая дата доставки, nil - недоставлен.
  # active_date - планируемая дата
  # self - экспедитор, который доставил
  def update_orders_status(date_delivered, plane_date)
    self.take_orders_delivered(nil, plane_date).update_all(delivered: date_delivered, expeditor: self.id)
  end

  # создает новый документ на отгрузку текущих заказов
  # items - состав отгрузки, список изделий с количеством мест
  # ad - планируемая дата отгрузки
  # self - экспедитор, который повезет
  # Возвращает заказ или false при неуспехе
  def new_waybill(ad, items)
    wb = self.expeditions.build {|ex| ex[:take_aboard] = ad}
    return nil unless wb
    wb[:amount_boxes] = items.sum(&:technic)
    wb
  end

end
