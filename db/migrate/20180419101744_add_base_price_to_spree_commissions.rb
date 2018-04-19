class AddBasePriceToSpreeCommissions < ActiveRecord::Migration[5.1]
  def change
    add_column :spree_commissions, :base_price, :decimal, precision: 10, scale: 2, default: 0.0, null: false
  end
end
