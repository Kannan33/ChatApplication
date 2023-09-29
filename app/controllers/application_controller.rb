class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  # handle 404 error
  def not_found_method
    respond_to do |format|
      format.html { redirect_to root_path, alert: 'Page not found' }
      format.js { render js: "alert('Page not found')", status: :unprocessable_entity }
    end
  end
    private
    # handle unauthorized error
    def user_not_authorized(exception)
      flash[:warn] = "You are not Authorized"
      redirect_back(fallback_location: root_path)
    end
end
