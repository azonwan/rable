class SessionsController < Devise::SessionsController
  def create
    resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new")
    reset_session
    sign_in(resource_name, resource)
    if mobile_device?
      redirect_to root_path
    else
      respond_with resource, :location => after_sign_in_path_for(resource)
    end
  end
end
