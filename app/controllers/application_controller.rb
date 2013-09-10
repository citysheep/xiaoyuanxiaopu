class ApplicationController < ActionController::Base
  protect_from_forgery

  # Auto-geocode the user's ip address and store in the session.
  geocode_ip_address

  # Get address from IP, if cannot, use the default hardcoded one
  def geo_lat
    session[:geo_location] ? session[:geo_location].lat : 22.299842230893535   
  end

  def geo_lng
    session[:geo_location] ? session[:geo_location].lng : 114.17249643179662  
  end

  def geo_address(lat, lng)
    (Geokit::Geocoders::GoogleGeocoder.reverse_geocode [lat, lng]).full_address
  end

  def create_shop
    shop = Shop.new
    if session[:location]
      shop.lat = session[:location][:lat]
      shop.lng = session[:location][:lng]
    else
      shop.lat = geo_lat
      shop.lng = geo_lng
    end
    shop.items.build
    shop
  end

end
