  class UsersController < ApplicationController
    
  before_filter :authenticate_user!
  
  def show
    if params[:id] == "profile"
      @user = current_user
    else
    	@user = User.find(params[:id])
    end
  end
 
  private
  	def is_admin
  	  @user.admin == 1
  	end  
end