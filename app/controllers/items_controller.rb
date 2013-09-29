# encoding: UTF-8
require 'will_paginate/array' 

class ItemsController < ApplicationController
  layout "application"
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

    location = curr_location
    items = Item.geo_scope(:origin=>[location[:lat], location[:lng]]).order("distance asc", "created_at desc")
    # items = Item.geo_scope(:origin=>[@lat, @lng], :within=>10000).order("distance asc", "buyer", "created_at desc")

    @cid = params[:category_id]
    if @cid
      items = items.where(:category_id=>@cid)
    end

    @items = items.paginate(:page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => items }
    end
  end

  def search
    location = curr_location
    if params[:search]
      @items = Item.search params[:search]
    else
      # @items = Item.geo_scope(:origin=>[@lat, @lng], :within=>10000).order("distance asc", "buyer", "created_at desc")
      @items = Item.geo_scope(:origin=>[location[:lat], location[:lng]]).order("distance asc", "buyer", "created_at desc")
    end

    @items = @items.paginate(:page => params[:page])

    respond_to do |format|
      format.html { render :index }
    end
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
    if current_user.shops
      @item = Item.new
      respond_to do |format|
        format.html # new.html.erb
        format.json { render :json => @item }
      end
    else
    # if there is no shop - return creation shop form
      @shop = ShopsHelper::create_shop()
      respond_to do |format|
        format.html { render "shops/new" }
        format.json { render :json => @shop }
      end
    end
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items
  # POST /items.json
  def create
    shop = Shop.find(params[:item][:shop_id])
    params[:item].merge!({
      lat: shop.lat,
      lng: shop.lng,
    })

    @item = Item.new(params[:item])
    @popup = true

    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, :notice => "<h4>货物成功发布啦！</h4><p></p><a class='social-share btn btn-info'>和好友分享</a>".html_safe }
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
        shop = Shop.find(params[:item][:shop_id])
        params[:item].merge!({
                                 lat: shop.lat,
                                 lng: shop.lng,
                             })
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
    current_user.id == item.shop.user.id
  end  

end
