require 'application_responder'

class ApplicationController < ActionController::Base
  before_action :authenticate

  self.responder = ApplicationResponder

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

  # :nocov:
  def authenticate
    return if Rails.env.test? || (ENV['USERNAME'].blank? || ENV['PASSWORD'].blank?)

    authenticate_or_request_with_http_basic do |username, password|
      username == ENV['USERNAME'] && password == ENV['PASSWORD']
    end
  end
  # :nocov:
end
