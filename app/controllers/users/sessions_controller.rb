# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  before_action :set_params, only: [:create]
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    @error_message = ""
    @user = User.new
    super
  end

  # POST /resource/sign_in
  def create
    @error_message = ""
    @user = User.find_by(email: chk_pass_params[:email])
    if @user && @user.valid_password?(chk_pass_params[:password])
      super
    else
      @user = User.new
      @error_message = "メールアドレスまたはパスワードが間違っています"
      render :new
    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  def after_sign_in_path_for(resource) 
    if current_user
      schedules_path
    end
  end

  #protected

  

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  private
  # deviseではform_tagが標準で称されているため、
  # form_withを使用するために一度userから値を出す
  def set_params
    params.require(:user).each do | key,value |
      params[key] = value
    end
  end
  def chk_pass_params
    params.permit(:email,:password)
  end
end
