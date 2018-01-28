class AddSalesNetworkAncestryToSpreeUser < ActiveRecord::Migration[5.1]
  def change
    add_column :spree_users, :sales_network_ancestry, :string
    add_index :spree_users, :sales_network_ancestry
  end
end
