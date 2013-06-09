class Shop < ActiveRecord::Base
  belongs_to :user
  belongs_to :city
  has_many :items
  has_many :follows
  has_many :following_users, :through => :follows, :source => :user

  acts_as_mappable
  self.per_page = 6 
end
