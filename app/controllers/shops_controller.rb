# encoding: UTF-8
require 'will_paginate/array' 

class ShopsController < ApplicationController
  geocode_ip_address
  before_filter :authenticate_user!, :only => [:new, :create, :edit, :update, :destroy]

  # GET /shops
  # GET /shops.json
  def index
    if params[:lat] && params[:lng]
      session[:location] = {
        :lat => params[:lat],
        :lng => params[:lng]
      }
    end

    if session[:location]
      @lat = session[:location][:lat]
      @lng = session[:location][:lng]
    else
      @lat = geo_lat
      @lng = geo_lng
    end

    # @shops = Shop.geo_scope(:origin=>[@lat, @lng], :within=>10000).order("distance asc", "created_at DESC")
    @shops = Shop.geo_scope(:origin=>[@lat, @lng]).order("distance asc", "created_at DESC")

    if params[:user_id]
      @shops = @shops.where(:user_id=>params[:user_id])
      @page_title = "#{User.find(params[:user_id]).name}的小铺"
    else
      @shops = @shops.select{|s| s.items.count > 0}
      @page_title = "您附近的小铺"
    end

    @shops = @shops.paginate(:page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @shops }
    end
  end

  # GET /shops/1
  # GET /shops/1.json
  def show
    if params[:auth]
      authenticate_user!
    end
    @shop = Shop.find(params[:id])
    @items = @shop.items.order("buyer", "created_at desc").paginate(:page => params[:page])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @shop }
    end
  end

  # GET /shops/new
  # GET /shops/new.json
  def new
    @shop = Shop.new
    @shop.lat = session[:location] ? session[:location][:lat] : geo_lat
    @shop.lng = session[:location] ? session[:location][:lng] : geo_lng
    @shop.items.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @shop }
    end
  end

  # GET /shops/1/edit
  def edit
    if is_shop_owner params[:id]
      @shop = Shop.find(params[:id])
    end
  end

  # POST /shops
  # POST /shops.json
  def create
    params[:shop][:user_id] = current_user.id
    @shop = Shop.new(params[:shop])
    @shop.city_id = City.geo_scope(:origin => @shop, :within => 15).order("distance asc").first.id

    @popup = true
    respond_to do |format|
      if @shop.save
        format.html { redirect_to @shop, :notice => "<h4>恭喜！您的小铺成功开张啦！</h4><p>但是<strong>只有发布过货物的小铺才可以显示在首页</strong>哦。您可以#{view_context.link_to('点击这里', new_item_path)}发布新货。<p><a class='social-share btn btn-info'>和好友分享</a></p>".html_safe }
        format.json { render :json => @shop, :status => :created, :location => @shop }
      else
        format.html { render :action => "new" }
        format.json { render :json => @shop.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /shops/1
  # PUT /shops/1.json
  def update
    if is_shop_owner params[:id]
      @shop = Shop.find(params[:id])
      params[:shop][:city_id] = City.geo_scope(:origin => @shop, :within => 15).order("distance asc").first.id

      respond_to do |format|
        if @shop.update_attributes(params[:shop])
          format.html { redirect_to @shop, :notice => '小铺资料成功更新啦！' }
          format.json { head :ok }
        else
          format.html { render :action => "edit" }
          format.json { render :json =>  @shop.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /shops/1
  # DELETE /shops/1.json
  def destroy
    if is_shop_owner params[:id]
      @shop = Shop.find(params[:id])
      @shop.destroy

      respond_to do |format|
        format.html { redirect_to shops_url }
        format.json { head :ok }
      end
    end
  end

  def is_shop_owner(shop_id)
    current_user.shops.any? { |shop| shop.id.to_s == shop_id }
  end

  def geo_address(lat, lng)
    (Geokit::Geocoders::GoogleGeocoder.reverse_geocode [lat, lng]).full_address
  end
end
