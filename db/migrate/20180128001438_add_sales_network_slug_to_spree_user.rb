  class AddSalesNetworkSlugToSpreeUser < ActiveRecord::Migration[5.1]
  def change
    add_column :spree_users, :sales_network_slug, :string
    add_index :spree_users, :sales_network_slug, unique: true
  end
end
