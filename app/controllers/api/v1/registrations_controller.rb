class Api::V1::RegistrationsController < Api::V1::ApiController

# User Registration APi
#   Url : http://maropost.dev:3000/api/v1/sign_up
#   type : post
#   Parameters: { "email": "ashish.api.test3@mailinator.com" }
def create
  if params[:email].nil? 
    render :xml=>{:code=> 500, :status=>"Failure", :message=>"Email can't be blank !"}
  else
    email = User.find_by_email(params[:email])
    if email.present?
     render :xml=>{ :code=> 500, :status=>"Failure", :message=>"Email is already exist !" }
    else
      small_rand = [*('a'..'z')].shuffle
      number_rand = [*('0'..'9')].shuffle
      cap_rand = [*('A'..'Z')].shuffle
      password_rand = small_rand[0..1].join + number_rand[0..6].join + cap_rand[0]
      params[:password] = password_rand
      user = User.new(:email => params[:email], :password=> params[:password], :password_confirmation=> params[:password], :token => params[:password])
      if user.save
        CustomMailer.registration(user).deliver_later
        render :xml=>{ :code=> 200, :status=>"Success", :message=>"Please check your email.", :user=>{email: user.email, authentication_token: user.authentication_token, created_at: user.created_at, updated_at: user.updated_at} }
      else
        render  :xml=>{ :code=> 500, :status=>"Failure", :message=>"Your email id is wrong."}
      end
    end
  end  
end
 
end