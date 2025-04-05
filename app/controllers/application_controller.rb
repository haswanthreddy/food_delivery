class ApplicationController < ActionController::API
  include ActionController::Cookies
  include ActionController::Helpers
  include ApiException::Handler
  include Authentication
end
