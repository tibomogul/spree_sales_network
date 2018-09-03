Spree::StoreController.class_eval do
  before_action :check_sponsor

  # 2018-02-01 We are getting errors
  # 'Couldn't find template for digesting: spree/store/cart_link'
  # just needed to add `template: false` to fresh_when call
  def cart_link
    render partial: 'spree/shared/link_to_cart'
    fresh_when(simple_current_order, template: false)
  end

  private
  def check_sponsor
    session[:sponsor] = params[:sponsor] if params[:sponsor].present? # always overwrite if there is new
  end
end