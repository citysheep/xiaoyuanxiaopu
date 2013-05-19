# encoding: UTF-8
class FollowsController < ApplicationController
  before_filter :authenticate_user!, :only => [:index, :create, :destroy]

  # GET /follows
  # GET /follows.json
  def index
    @shops = current_user.followed_shops.paginate(:page => params[:page])
    @page_title = "您关注的小铺"
    @follow = true
    respond_to do |format|
      format.html { render "shops/index" }
      format.json { render :json  => @shops }
    end
  end

  # POST /follows
  # POST /follows.json
  def create
    params[:follow][:user_id] = current_user.id
    @follow = Follow.new(params[:follow])

    respond_to do |format|
      if @follow.save
        format.html { redirect_to @follow, :notice =>  '关注小铺成功!' }
        format.json { render :json => @follow, :status => :created, :location => @follow }
      else
        format.html { render :action => "new" }
        format.json { render :json =>  @follow.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /follows/1
  # DELETE /follows/1.json
  def destroy
    @follow = Follow.find(params[:id])
    @follow.destroy

    respond_to do |format|
      format.html { redirect_to follows_url }
      format.json { head :ok }
    end
  end
    
end
