class UserRegistrationsController < Devise::RegistrationsController
  def create
    if simple_captcha_valid?
      super
    else
      build_resource
      resource.errors.add(:base, t('simple_captcha.error')) if resource.valid?
      render :new
    end
  end

  protected

  # See https://juntoo.co/s/3f9717c
  # This controller was already started on.
  def after_inactive_sign_up_path_for(resource)
    "#{ENV['PLEATHUB_URL']}/?fresh=y"
  end
end
