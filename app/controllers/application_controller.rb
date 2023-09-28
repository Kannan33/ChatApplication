class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def not_found_method
    respond_to do |format|
      format.html { redirect_to users_path, alert: 'Page not found' }
      format.js { render js: "alert('Page not found')", status: :unprocessable_entity }
    end
  end
end
