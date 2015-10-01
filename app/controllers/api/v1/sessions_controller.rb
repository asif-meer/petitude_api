class Api::V1::SessionsController < ApplicationController
  skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }

  respond_to :json

  def create
    # warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
    authorized_user = User.authenticate(params[:email],params[:password])
    if authorized_user
      render :status => 200,
             :json => { :success => true,
                        :info => "Logged in",
                        :data => { :auth_token => authorized_user.authentication_token } }
    else
      render :status => :unprocessable_entity,
             :json => { :success => false,
                        :info => 'email or password is invalid',
                        :data => {} }

    end
  end

  def destroy
    # puts "resource_name: #{resource_name}"
    # warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
    # current_user.update_column(:authentication_token, nil)
    # render :status => 200,
    #        :json => { :success => true,
    #                   :info => "Logged out",
    #                   :data => {} }

    resource  = User.find_by_authentication_token(params[:auth_token])
    if resource
      resource.update_column(:authentication_token, nil)
      render :status => 200,
             :json => { :success => true,
                        :info => "Logged out",
                        :data => {} }
    else
      render :status => :unprocessable_entity,
             :json => { :success => false,
                        :info => 'unprocessable entity',
                        :data => {} }
    end

  end

  def failure
    render :status => 401,
           :json => { :success => false,
                      :info => "Login Failed",
                      :data => {} }
  end
end