class LocationsController < ApplicationController
    geocode_ip_address
    
    def get
      respond_to do |format|
        format.json { render :json => {
            :lat => session[:location] ? session[:location][:lat] : session[:geo_location] ? session[:geo_location].lat : 22.325116,
            :lng => session[:location] ? session[:location][:lng] : session[:geo_location] ? session[:geo_location].lng : 114.175415
          } 
        }
      end
    end
end
