class CustomFailure < Devise::FailureApp
  def http_auth_body
    {
      message: i18n_message,
      key: warden_options[:message]
    }.to_json
  end
end
