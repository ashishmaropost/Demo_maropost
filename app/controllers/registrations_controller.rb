class RegistrationsController < Devise::RegistrationsController
  
	def create
      small_rand = [*('a'..'z')].shuffle
      number_rand = [*('0'..'9')].shuffle
      cap_rand = [*('A'..'Z')].shuffle
      password_rand = small_rand[0..1].join + number_rand[0..6].join + cap_rand[0]
		  params[:user][:password] = password_rand
      build_resource(sign_up_params)
      resource.token = params[:user][:password]
      resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        # set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
        
        signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
        "#{flash[:notice] = "Please check your email."}"
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  def after_sign_up_path_for(resource)
    "#{CustomMailer.registration(resource).deliver_later}"
   	root_path
  end

end
