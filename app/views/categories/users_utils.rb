module UsersUtils
  module ClassMethods
    def is_admin
      user_signed_in? && current_user.admin == 1
    end
  end
  
  def self.included(receiver)
    receiver.extend ClassMethods
  end
end
