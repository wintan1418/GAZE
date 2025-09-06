class Public::BaseController < ApplicationController
  # Base controller for public namespace
  # No authentication required
  
  include SnippetsHelper
end