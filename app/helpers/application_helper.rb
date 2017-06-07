module ApplicationHelper

   def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end  
  def flash_class(level)
    case level
      when 'info' then "alert alert-info"
      when 'notice','success' then "alert alert-success"
      when 'error','danger' then "alert alert-danger"
      when 'alert' then "alert alert-warning"
    end
   end
end
