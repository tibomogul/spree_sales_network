Spree::Order.class_eval do
  has_many :commissions

  alias :old_finalize! :finalize!

  def finalize!
    old_finalize!
    if user && user.sales_network_slug.blank? && user.orders.where(state: 'complete').count > 0
      user.update_user_sales_network_slug
      user.reload
    end
    Spree::Commission.create_commissions self
  end

  alias :old_after_cancel :after_cancel

  def after_cancel
    commissions.each(&:cancel!)
    old_after_cancel
  end

  alias :old_persist_user_address! :persist_user_address!

  def persist_user_address!
    old_persist_user_address!
    return unless user
    user.update_user_sponsor
    user.reload
  end
end