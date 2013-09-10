class Item < ActiveRecord::Base
  include Paperclip
  belongs_to :category
  belongs_to :shop
  acts_as_mappable
  
  has_attached_file :photo, :styles => { :original => '400x400>', :small => '360x360>' }
  validates_attachment_presence :photo

  self.per_page = 6

	def self.search(search)
	  search_condition = "%" + search + "%"
	  find(:all, :conditions => ['name LIKE ? OR description LIKE ?', search_condition, search_condition])
	end  
end
