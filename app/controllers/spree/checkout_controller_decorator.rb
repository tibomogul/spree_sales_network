Spree::CheckoutController.class_eval do
  append_before_action :set_sponsor, only: [:update]

  private
  def set_sponsor
    RequestStore.store[:sponsor] = session[:sponsor]
  end
end