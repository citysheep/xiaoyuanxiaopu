class AccountController < ApplicationController
    before_filter :authenticate_user!, :only => [:show, :inbox]
  
    def show
    end
    
    def inbox
      redirect current_user
    end
end
