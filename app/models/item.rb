class Item < ActiveRecord::Base
  include Paperclip
  belongs_to :category
  belongs_to :shop
  belongs_to :zone

  has_attached_file :photo, :styles => { :original => '500x500>' }, :processors => [:thumbnail, :add_url]
  validates_attachment_presence :photo
  validates :name, :price, :shop_id, :zone_id, presence: true
  attr_accessible :name, :price, :description, :shop_id, :category_id, :zone_id, :photo
  self.per_page = 6

	def self.search(search)
	  search_condition = "%" + search + "%"
	  find(:all, :conditions => ['name LIKE ? OR description LIKE ?', search_condition, search_condition])
	end  
end