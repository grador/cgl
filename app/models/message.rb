class Message < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :body

  has_many :sendmen, dependent: :destroy
  accepts_nested_attributes_for :sendmen, allow_destroy: true
  # не сохраняет получателей которых пись
  accepts_nested_attributes_for :sendmen, reject_if: proc {
                                         |attributes| attributes['sender'].blank? || attributes['sender']=='0'|| attributes['sender']==0}


end
