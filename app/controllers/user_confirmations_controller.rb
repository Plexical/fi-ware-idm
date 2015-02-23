class UserConfirmationsController < Devise::ConfirmationsController
  protected

  def after_confirmation_path_for(resource_name, resource)
    "#{ENV['PLEATHUB_URL']}/?fresh=verified"
  end
end
