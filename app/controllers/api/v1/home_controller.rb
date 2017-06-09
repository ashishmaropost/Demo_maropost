
class Api::V1::HomeController < Api::V1::ApiController
	before_action :authenticate_user!, only:[:contact_us]
  skip_before_filter :verify_authenticity_token, :only => [:error_404]
  # Conatact APi
#   Url : http://maropost.dev:3000/api/v1/contact_us?user_token=9ejBcmTxy-EsxRynAPh1
#   type : post
#   Parameters: { "name":"ashish", "email":"ashish1@mailinator.com", "mobile_number":"9999999999", "description":"Hello world, Programming is best future." }
  def contact_us
  	if ((params[:email].nil? || params[:email] == "") || (params[:name].nil? || params[:name] == "") || (params[:mobile_number].nil? || params[:description] == "") || (params[:description].nil? || params[:description] == ""))
    render :json=>{:code=> 500, :status=>"Failure", :message=>"Fields can't be blank !"}
    else
	  	@contact = Contact.new(name: params[:name], email: params[:email], mobile_number: params[:mobile_number], description: params[:description]) 
      if @contact.save
      	CustomMailer.contact(@contact).deliver_now
      	render :json=>{ :code=>200, :status=>"Success", :message=>"Thank you for contacting with us", :contact=> @contact }
        else
      	render :json=>{ :code=>500,  :status=>"Failure", :message=>"Something went wrong" }
      end
    end
  end
  
  def error_404
    @requested_path = request.path
     render :json=>{ :code=>500,  :status=>"Failure", :message=>"Invalid url" }
  end

end