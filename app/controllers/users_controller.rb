  class UsersController < ApplicationController
    
  before_filter :authenticate_user!
  before_filter :authenticate_admin!, :except  => :show

  def show
    if params[:id] == "profile"
      @user = current_user
    else
    	@user = User.find(params[:id])
    end
  end

  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @users }
    end
  end

end