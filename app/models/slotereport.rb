class Slotereport < ActiveRecord::Base
  belongs_to :item
  accepts_nested_attributes_for :item
  belongs_to :report, autosave: true


end
