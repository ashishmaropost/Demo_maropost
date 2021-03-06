class Api::V1::SessionsController < Api::V1::ApiController

 #User sing_in Api
 #url: http://maropost.dev:3000/api/v1/sign_in
 #type : post
 #parameters:{"email":"ashish.api.test3@mailinator.com", "password":"ys9384106C"}
  def create
		email = params[:email]
    password = params[:password]
    if request.format != :xml
      render  :xml=>{:code=>500, :status=>"Failure", :message=>"The request must be xml"}
      return
    end
    if email.nil? and password.nil?
      render :xml=>{:code=>500, :status=>"Failure", :message=>"The request must contain the user email and password."}
      return
    end

    @user=User.find_by_email(email.downcase)
    if @user.blank?
      logger.info("User #{email} failed signin, user cannot be found.")
      render :xml=>{:code=>500, :status=>"Failure", :message=>"Invalid email or passoword."}
      return
    end
     if not @user.valid_password?(password)
      logger.info("User #{email} failed signin, password \"#{password}\" is invalid")
      render :xml=>{:code=>500, :status=>"Failure",:message=>"Invalid email or password."}
    else
      sign_in("user", @user)
      render :xml=>{:code=>200, :status =>"Success", :message=>"Successfully sign in.",:data=>{email: @user.email}}
     end
  end


#user sing_out
#url :http://maropost.dev:3000/api/v1/sign_out
#type :delete
  def destroy
  	if request.format != :xml
      render :xml=>{:code=>500, :status=>"Failure", :message=>"The request must be xml"}
      return
    end     
    if  Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)        
      render :xml=>{:code=>200, :status=>"Success", :message=>"Successfully sign out."}
      return
    else
      render :xml=>{:code=>500, :status=>"Failure", :message=>"0"}
      return
    end
 end
  

end