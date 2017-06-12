class Api::V1::ApiController < ApplicationController
	skip_before_action :verify_authenticity_token 
	respond_to :xml
	helper_method :current_user
	include ApplicationHelper
	  # Authenticate user.
	def current_user
	  @current_user ||= User.where(authentication_token: params[:user_token]).first 
	end

	def authenticate_user!
	    render xml:['401 Unauthorized!'],status: 401 unless current_user
	end

end