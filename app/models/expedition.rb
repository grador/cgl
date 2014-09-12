class Expedition < ActiveRecord::Base

  belongs_to :user
  has_many :loadups, dependent: :destroy
  accepts_nested_attributes_for :loadups, allow_destroy: true

  include MakeStringOrderExpedition
  include SomeClassMethod

  def is_active
    !self.updated_at.to_date.past?
  end

  def change_status
    self.is_active ?  Date.yesterday : Date.today
  end

  def change_obj_status
    self.updated_at= self.change_status
  end

  def in_time?
    date = self[:updated_at].to_date
    date == self[:take_aboard].to_date ? 'В срок': date
  end
end
