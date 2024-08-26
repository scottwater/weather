class ApplicationController < ActionController::Base
  # Allow modern browsers and Sizzy app
  allow_browser versions: :modern,
    unless: -> { ENV["SKIP_BROWSER_CHECK"] == "true" }

  private

  # This is a quick workaround to obtain the end user's IP Address
  # when the app is proxied with CloudFlare
  # You likely want to do a bit more in an application that
  # does any real validation of the IP address validation.
  def client_ip
    request.env["HTTP_CF_CONNECTING_IP"] || request.remote_ip
  end
end
