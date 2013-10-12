# encoding: UTF-8
class MessagesController < ApplicationController
    
  before_filter :authenticate_user!
  before_filter :set_user
  
  def index
    if params[:mailbox] == "sent"
      @messages = @user.sent_messages
    else
      @messages = @user.received_messages
    end
  end
  
  def show
    @message = Message.read_message(params[:id], current_user)
    @message.body = @message.body.strip
  end
  
  def new
    @message = Message.new

    if params[:item_id]
      item = Item.find(params[:item_id])
      @recipient = item.shop.user
      @message.subject = "我想買#{item.name}"
    end

    if params[:reply_to]
      @reply_to = @user.received_messages.find(params[:reply_to])
      unless @reply_to.nil?
        @recipient = @reply_to.sender
        @message.subject = "Re: #{@reply_to.subject}"
      end
    end

    @message.to = @recipient.id

  end
  
  def create
    @message = Message.new(params[:message])
    @message.sender = @user
    @message.recipient = User.find(params[:message][:to])

    if @message.save
      SiteMailer.notification_email(@message).deliver
      flash[:notice] = "信息發送成功！"
      redirect_to messages_path
    else
      render :action => :new
    end
  end

  def destroy
    @message = Message.find(:first, :conditions => ["messages.id = ? AND (sender_id = ? OR recipient_id = ?)", params[:id], @user, @user])
    @message.mark_deleted(@user) unless @message.nil?  
    flash[:notice] = "信息刪除成功！"
    redirect_to :back
  end

  private
    def set_user
      @user = current_user
    end
end