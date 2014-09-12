class Loadup < ActiveRecord::Base

  validates :quantity, numericality: {greather_than: 0}, presence: true,  on: :create
  validates :q_box, numericality: {greather_than: 0}, presence: true,  on: :create

  belongs_to :item
  accepts_nested_attributes_for :item
  belongs_to :user, autosave: true
  accepts_nested_attributes_for :user
  belongs_to :expedition, autosave: true
  accepts_nested_attributes_for :expedition

end
