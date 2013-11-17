# encoding: UTF-8
require 'will_paginate/array'

class ShopsController < ApplicationController
  before_filter :authenticate_user!, :only => [:new, :create, :edit, :update, :destroy, :my_shop]

  # GET /shops
  # GET /shops.json
  def index
    if params[:user_id]
      @shops = Shop.where(:user_id=>params[:user_id])
      @page_title = "#{User.find(params[:user_id]).name}的小铺"
      @shops = @shops.paginate(:page => params[:page])
    end

    respond_to do |format|
      format.html { render :index }
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
    @items = @shop.items.order('buyer', 'created_at desc').paginate(:page => params[:page])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @shop }
    end
  end

  # GET /shops/new
  # GET /shops/new.json
  def new
    @shop = create_shop()

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

    respond_to do |format|
      if @shop.save
        format.html { redirect_to @shop, :notice => "<h4>恭喜！你的小铺“#{@shop.name}”成功开张啦！<a class='social-share'>点击这里和好友分享</a></h4><h6>只有发布过货物的小铺才可以显示在首页哦。你可以#{view_context.link_to('点击这里', new_item_path)}发布新货。</h6>".html_safe }
        format.json { render :json => @shop, :status => :created, :location => @shop }
      else
        format.html { render :action => 'new' }
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
          format.html { render :action => 'edit' }
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

  def my_shop
    params[:user_id] = current_user.id
    index()
  end

  def is_shop_owner(shop_id)
    current_user.shops.any? { |shop| shop.id.to_s == shop_id }
  end

end
