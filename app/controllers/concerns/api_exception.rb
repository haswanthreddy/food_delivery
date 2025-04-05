module ApiException
  extend ActiveSupport::Concern

  class BaseError < StandardError
  end

  module Handler
    def self.included(controller_class)
      controller_class.class_eval do
        EXCEPTIONS.each do |exception_name, context|
          unless ApiException.const_defined?(exception_name)
            ApiException.const_set(exception_name, Class.new(BaseError))
            exception_name = "ApiException::#{exception_name}"
          end

          rescue_from exception_name do |exception|
            render status: context[:code], json: { code: context[:code], status: context[:status] , error: context[:error] }.compact
          end
        end
      end
    end
  end
end
