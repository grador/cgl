class Sendman < ActiveRecord::Base
  belongs_to :message, autosave: true
  accepts_nested_attributes_for :message
  belongs_to :user, autosave: true
  accepts_nested_attributes_for :user

end
