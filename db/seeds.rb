# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)


require 'csv'

puts 'Populating Cities...'
City.destroy_all
CSV.open("#{Rails.root}/db/data/cities.csv", 'r').each do |row|
  City.create(:name => row[0], :lng => row[1], :lat => row[2])
end
puts 'Populating Cities completed!'


puts 'Enrich Shop City Info...'
Shop.find(:all).each { |shop|
  if !shop.city
	  shop.update_attributes({:city_id => City.geo_scope(:origin => shop, :within => 10).order("distance asc").first.id})	
  end 
}
puts 'Enrich Shop City Info completed!'
