Spree::User.class_eval do
  has_ancestry ancestry_column: 'sales_network_ancestry', max_depth: 3

  has_many :commissions
end