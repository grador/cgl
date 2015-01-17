class Message < ActiveRecord::Base
  validates_presence_of :name, length: { maximum: NAME_LENGTH }, on: :create
  validates_presence_of :body, length: { maximum: BODY_LENGTH }, on: :create

  has_many :sendmen, dependent: :destroy
  accepts_nested_attributes_for :sendmen, allow_destroy: true
  # не сохраняет получателей которых пись
  accepts_nested_attributes_for :sendmen, reject_if: proc {
                                         |attributes| attributes['sender'].blank? || attributes['sender']=='0'|| attributes['sender']==0}


end
