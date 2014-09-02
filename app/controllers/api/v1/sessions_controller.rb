module Api
  module V1
    class SessionsController < Api::V1::ApiController
    	skip_before_filter :verify_authenticity_token, :only => [:create ]
    	before_filter :ensure_params_exist
 def create
    #build_resource
    user = User.find_for_database_authentication(:email=>params[:user_login][:email])
    return invalid_login_attempt unless user
 
    if user.valid_password?(params[:user_login][:password])
      sign_in("user", user)
      #render :json=> {:success=>true, :auth_token=>resource.authentication_token, :email=>resource.email}
      render :json=> user.as_json(:auth_token=>user.authentication_token, :email=>user.email), :status=>201
      return
    end
    invalid_login_attempt
  end
  
  def destroy
    sign_out(resource_name)
  end
 
  protected
  def ensure_params_exist
    return unless params[:user_login].blank?
    render :json=>{:success=>false, :message=>"missing user_login parameter"}, :status=>422
  end
 
  def invalid_login_attempt
    warden.custom_failure!
    render :json=> {:success=>false, :message=>"Error with your login or password"}, :status=>401
  end

    end
  end
end