class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
 
   # You want to get exceptions in development, but not in production.
  unless Rails.application.config.consider_all_requests_local
    rescue_from ActionController::RoutingError, with: -> { render_404  }
    rescue_from ActionController::UnknownController, with: -> { render_404  }
    rescue_from ActiveRecord::RecordNotFound, with: -> { render_404  }
  end

  def render_404
    respond_to do |format|
      format.html { render template: 'errors/not_found', status: 404 }
      format.all { render nothing: true, status: 404 }
    end
  end

end
