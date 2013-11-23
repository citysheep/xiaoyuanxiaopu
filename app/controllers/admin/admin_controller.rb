class Admin::AdminController < ApplicationController
  before_filter :is_admin
end