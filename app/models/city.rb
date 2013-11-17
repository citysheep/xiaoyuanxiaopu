class City < ActiveRecord::Base
  has_many :zones
  acts_as_mappable
end
