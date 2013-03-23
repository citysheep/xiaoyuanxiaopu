# encoding: UTF-8
class SiteMailer < ActionMailer::Base
  default :from => "mywebmarket@mywebmarket.com"

  def notification_email(message)
    @message  = message
    mail(:to => message.recipient.email, :subject => " 校園小鋪－－您有新的留言")
  end
end
