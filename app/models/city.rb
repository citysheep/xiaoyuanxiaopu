class City < ActiveRecord::Base
  has_many :zones

  def self.sort_by_name
    City.order('name asc')
  end
end
