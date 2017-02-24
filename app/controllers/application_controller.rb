class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?

	protected

    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :title, :department, :nature_of_job, :email, :password) }
        devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:name, :email, :password, :current_password,  :title, :department, :nature_of_job) }
    end

    before_filter :set_current_user

    def set_current_user
      Booking.current_user = current_user
    end
end
