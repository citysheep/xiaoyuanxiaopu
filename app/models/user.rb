class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :confirmable

  # # Setup accessible (or protected) attributes for your model
  # attr_accessible :email, :password, :password_confirmation, :remember_me, :name

  has_many :items
  has_many :shops
  has_many :follows
  has_many :followed_shops, :through => :follows, :source => :shop
  has_many :authorizations
  has_private_messages

  validates_uniqueness_of :email

  def self.create_from_auth(hash)
    info = hash[:info]
    if info[:urls][:figureurl_1]
      open_link = info[:urls][:figureurl_1]
    else
      open_link = info[:urls][:Renren]
    end
    user_hash = {:name => info[:name], :open_id => info[:uid], :open_avatar => info[:image], :open_link => open_link}
    user = (User.find_by_open_id(user_hash[:open_id])) || User.new(user_hash)
    user.skip_confirmation! 
    user.save!
    user
  end
end
