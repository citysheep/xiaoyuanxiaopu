# encoding: UTF-8
require 'will_paginate/array' 

class ItemsController < ApplicationController
  layout "application"
  geocode_ip_address
  before_filter :get_item, :only => [:show, :edit, :update, :destroy, :soldout]
  before_filter :authenticate_user!, :only => [:new, :create, :edit, :update, :destroy, :soldout]
  
  def get_item
    @item = Item.find(params[:id])
  end

  # GET /items
  # GET /items.json
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
      @items = Item.geo_scope(:origin=>[@lat, @lng]).order("distance asc", "buyer", "created_at desc")
    else
      @items = Item.scoped.order("buyer", "created_at desc")
    end

    @cid = params[:category_id]
    if @cid
      @items = @items.where(:category_id=>@cid)
    end

    @items = @items.paginate(:page => params[:page])

    if !@lat || !@lng
      @lat = 22.299842230893535
      @lng = 114.17249643179662
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @items }
    end
  end

  def geo_address(lat, lng)
    (Geokit::Geocoders::GoogleGeocoder.reverse_geocode [lat, lng]).full_address
  end

  # GET /items/1
  # GET /items/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @item }
    end
  end

  # GET /items/new
  # GET /items/new.json
  def new
    @item = Item.new
    @item.lat = session[:location] ? session[:location][:lat] : session[:geo_location] ? session[:geo_location].lat : 22.325116
    @item.lng = session[:location] ? session[:location][:lng] : session[:geo_location] ? session[:geo_location].lng : 114.175415  
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @item }
    end
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items
  # POST /items.json
  def create
    params[:item][:user_id] = current_user.id
    
    if params[:item][:shop_id] && params[:item][:shop_id]!=""
      shop = Shop.find(params[:item][:shop_id])
      params[:item][:lat] = shop.lat
      params[:item][:lng] = shop.lng
    end
    
    @item = Item.new(params[:item])
    @popup = true

    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, :notice => '货物成功发布啦！' }
        format.json { render :json => @item, :status => :created, :location => @item }
      else
        format.html { render :action => "new" }
        format.json { render :json => @item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /items/1
  # PUT /items/1.json
  def update
    if is_owner (@item)
      respond_to do |format|
        if @item.update_attributes(params[:item])
          format.html { redirect_to @item, :notice => '货物成功更新啦！' }
          format.json { head :ok }
        else
          format.html { render :action => "edit" }
          format.json { render :json => @item.errors, :status => :unprocessable_entity }
        end
      end
    end 
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    if is_owner (@item)
      @item.destroy
  
      respond_to do |format|
        format.html { redirect_to items_url }
        format.json { head :ok }
      end
    end
  end
  
  def is_owner(item)
    current_user.id == item.user.id
  end  

end
