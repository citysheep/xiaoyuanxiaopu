class ApplicationController < ActionController::Base
  protect_from_forgery

  # Auto-geocode the user's ip address and store in the session.
  #geocode_ip_address
  #
  #def curr_location
  #  if session[:zone]
  #    {
  #      :lat => session[:location][:lat],
  #      :lng => session[:location][:lng]
  #    }
  #  else
  #    {
  #      :lat => session[:geo_location] ? session[:geo_location].lat : 22.299842230893535,
  #      :lng => session[:geo_location] ? session[:geo_location].lng : 114.17249643179662
  #    }
  #  end
  #end
  #
  #def geo_address(lat, lng)
  #  (Geokit::Geocoders::GoogleGeocoder.reverse_geocode [lat, lng]).full_address
  #end

  def create_shop
    shop = Shop.new
    shop.items.build
    shop
  end


  def is_admin
    user_signed_in? && current_user.is_admin
  end

end
