class AddRateToSpreeCommission < ActiveRecord::Migration[5.1]
  def change
    add_column :spree_commissions, :rate, :decimal, precision: 2, scale: 2, default: 0.0, null: false
  end
end
