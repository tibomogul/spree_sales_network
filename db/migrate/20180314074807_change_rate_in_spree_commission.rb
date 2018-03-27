class ChangeRateInSpreeCommission < ActiveRecord::Migration[5.1]
  def change
    change_column :spree_commissions, :rate, :decimal, :precision => 4, :scale => 2
  end
end
