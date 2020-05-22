class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  require "date"
  require "holiday_japan" #祝日判定用
  require "securerandom"  #乱数生成用(chkdig)

  def const
    @wd = ["日","月","火","水","木","金","土"]
  end

  def isholiday(d)
    if HolidayJapan.check(d)
      return "holiday"
    end
    if d.saturday?
      return "saturday"
    end
    if d.sunday?
      return "sunday"
    end
    return "weekday"
  end

  helper_method :isholiday

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name,:image_name])
  end

end
