class HomeController < ApplicationController
  before_action :authenticate_user!, only:[:contact_us, :about]
  def index
  end

  def contact_us
  	if params[:email].present?
	  	@contact = Contact.new(name: params[:name], email: params[:email], mobile_number: params[:mobile_number], description: params[:description]) 
	  	respond_to do |format|
	      if @contact.save
	      	CustomMailer.contact(@contact).deliver_now
	        format.html { redirect_to '/', success: 'Thank you ? We will contact soon.' }
	      else
	        format.html { redirect_to "/contact_us", danger: "Something went wrong! Please check again." }
	      end
	    end
   end
  end
 
 def about
 	@abouts = About.all
 end
end
