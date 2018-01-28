Spree::StoreController.class_eval do
  before_action :check_sponsor

  private
  def check_sponsor
    session[:sponsor] ||= params[:sponsor]
  end
end