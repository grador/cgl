class Sendman < ActiveRecord::Base
  validates :sender, numericality: { greather_than: 0 }
  validates_presence_of :user_id, :status

  belongs_to :message, autosave: true
  accepts_nested_attributes_for :message
  belongs_to :user, autosave: true
  accepts_nested_attributes_for :user

  # Модуль интерпретаторов данных для некоторых классов
  include MakeStringOrderExpedition
  include MakeString

  def self.take_letters_for_admin
    all.order('id DESC')
  end

  def self.take_new_letters(user)
    where(user_id: user.id, status: NEW).order('id DESC')
  end
end
