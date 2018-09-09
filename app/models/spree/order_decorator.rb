Spree::Order.class_eval do
  has_many :commissions

  alias :old_finalize! :finalize!

  def finalize!
    old_finalize!
    if user && user.orders.where(state: 'complete').count > 0
      update_user_sales_network_slug
      update_user_and_reload
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
    update_user_sponsor
    update_user_and_reload
  end

  private 
  def generate_sales_network_slug
    slug = ActiveSupport::Inflector.parameterize("#{bill_address_firstname} #{bill_address_lastname}")
    while Spree::User.find_by(sales_network_slug: slug) do
      slug = ActiveSupport::Inflector.parameterize("#{bill_address_firstname} #{SecureRandom.hex(5)} #{bill_address_lastname}")
    end
    slug
  end

  def update_user_sales_network_slug
    if user&.sales_network_slug.blank?
      user.sales_network_slug = generate_sales_network_slug
    end
  end

  def update_user_sponsor
    if user&.parent.nil? && !RequestStore.store[:sponsor].blank?
      user.parent = Spree::User.find_by(sales_network_slug: RequestStore.store[:sponsor])
    end
  end

  def update_user_and_reload
    if user.changed?
      user.save
      user.reload
    end
  end
end