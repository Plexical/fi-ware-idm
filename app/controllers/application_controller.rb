class ApplicationController < ActionController::Base
  protect_from_forgery
  include SimpleCaptcha::ControllerHelpers

  private

  # Overwriting the sign_out redirect path method
  # See https://juntoo.co/s/10ca298
  def after_sign_out_path_for(resource_or_scope)
    "#{ENV['PLEATHUB_URL']}/"
  end
end
