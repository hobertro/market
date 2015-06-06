class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  include RelationshipsHelper
  before_filter :blocked_relationships?

end
