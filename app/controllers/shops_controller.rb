# encoding: UTF-8
require 'will_paginate/array' 

class ShopsController < ApplicationController
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
      @address = geo_address(@lat, @lng)
      @shops = Shop.geo_scope(:origin=>[@lat, @lng]).order("distance asc", "created_at DESC")
    else
      @shops = Shop.scoped.order("created_at DESC")
    end

    if params[:action] == "showMyShops"
      @uid = current_user.id
    else
      @uid = params[:user_id]
    end

    if @uid
      @shops = @shops.where(:user_id=>@uid)
    end

    @shops = @shops.paginate(:page => params[:page])

    if !@lat || !@lng
      @lat = 22.299842230893535
      @lng = 114.17249643179662
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @shops }
    end
  end

  def frontpage
    @shops = Shop.find(:all, :order => "created_at desc", :limit => 6)

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
    @shop.lat = session[:location] ? session[:location][:lat] : session[:geo_location] ? session[:geo_location].lat : 22.325116
    @shop.lng = session[:location] ? session[:location][:lng] : session[:geo_location] ? session[:geo_location].lng : 114.175415 

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
    @popup = true
    respond_to do |format|
      if @shop.save
        format.html { redirect_to @shop, :notice => '你的小铺开张啦！恭喜！' }
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
