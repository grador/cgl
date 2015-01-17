class Sendman < ActiveRecord::Base
  validates :sender, numericality: { greather_than: 0 }, on: :create
  validates_presence_of :user_id, :status

  belongs_to :message, autosave: true
  accepts_nested_attributes_for :message
  belongs_to :user, autosave: true
  accepts_nested_attributes_for :user

  # Модуль интерпретаторов данных для некоторых классов
  include MakeStringOrderExpedition
  include SomeClassMethod
  include MakeString

  def self.take_new_letters(user)
    get_for_user(user).where(status: NEW).order('id DESC')
  end

end
