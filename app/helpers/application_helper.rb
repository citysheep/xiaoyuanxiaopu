module ApplicationHelper
  def is_shop_owner(shop)
    user_signed_in? && current_user.id == shop.user.id
  end
end
