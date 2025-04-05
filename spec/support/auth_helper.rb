module AuthHelper
  def login_as(resource_name, email_address, password)
    post "/api/v1/#{resource_name.to_s}s/sessions/", params: { email_address: email_address, password: password }

    response.cookies
  end
end