class ApplicationController < ActionController::Base
  # Allow modern browsers and Sizzy app
  allow_browser versions: :modern,
    unless: -> { ENV["SKIP_BROWSER_CHECK"] == "true" }
end
