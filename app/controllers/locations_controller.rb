class LocationsController < ApplicationController
    geocode_ip_address
    
    def get
      respond_to do |format|
        format.json { render :json => {
            :lat => session[:location] ? session[:location][:lat] : geo_lat
            :lng => session[:location] ? session[:location][:lng] : geo_lng
        }
      end
    end
end
