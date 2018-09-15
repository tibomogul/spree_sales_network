Spree::User.class_eval do
  has_ancestry ancestry_column: 'sales_network_ancestry', max_depth: 3

  has_many :commissions

  after_create :update_user_sales_network_slug

  def update_user_sponsor
    if parent.nil? && !RequestStore.store[:sponsor].blank?
      self.parent = Spree::User.find_by(sales_network_slug: RequestStore.store[:sponsor])
      save!
    end
  end

  def update_user_sales_network_slug
    if sales_network_slug.blank? && (try(:account_firstname).present? || try(:account_lastname).present?)
      self.sales_network_slug = generate_sales_network_slug
      save!
    end
  end

  private 

  def generate_sales_network_slug
    firstname = try(:account_firstname).presence
    lastname = try(:account_lastname).presence
    fullname = "#{firstname} #{lastname}"
    slug = ActiveSupport::Inflector.parameterize(fullname)
    while Spree::User.find_by(sales_network_slug: slug) do
      slug = ActiveSupport::Inflector.parameterize("#{firstname} #{SecureRandom.hex(5)} #{lastname}")
    end
    slug
  end
end