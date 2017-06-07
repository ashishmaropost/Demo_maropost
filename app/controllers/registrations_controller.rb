class RegistrationsController < Devise::RegistrationsController
  
  def after_sign_up_path_for(resource)
  	"#{CustomMailer.registration(resource).deliver_later}"
   	root_path
  end
end