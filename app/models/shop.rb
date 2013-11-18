class Shop < ActiveRecord::Base
  belongs_to :user
  belongs_to :zone
  has_many :items
  has_many :follows
  has_many :following_users, :through => :follows, :source => :user
  has_attached_file :picture, :styles => { :original => '300x300>', :small => '50x50>' }
  attr_accessible :name, :user_id, :zone_id, :description, :items_attributes
  accepts_nested_attributes_for :items, :allow_destroy => true

  self.per_page = 6

  def self.within_zone(zone)
    Shop.where(:zone_id => zone)
  end

end
