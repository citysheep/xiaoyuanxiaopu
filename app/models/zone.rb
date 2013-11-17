class Zone < ActiveRecord::Base
  belongs_to :city
  has_many :items
end
