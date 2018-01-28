Spree::Order.class_eval do
  alias :old_finalize! :finalize!

  def finalize!
    old_finalize!
    if user && user.sales_network_slug.blank? && user.orders.where(state: 'complete').count > 0
      user.update_attribute(:sales_network_slug, generate_sales_network_slug)
      user.reload
    end
  end

  def generate_sales_network_slug
    ActiveSupport::Inflector.parameterize("#{bill_address_firstname} #{bill_address_lastname}")
  end

end