class CreateSpreeCommissions < ActiveRecord::Migration[5.1]
  def change
    create_table :spree_commissions do |t|
      t.integer :order_id
      t.integer :user_id
      t.decimal :amount, precision: 10, scale: 2, null: false

      t.timestamps null: false
    end
    add_index :spree_commissions, :order_id
    add_index :spree_commissions, :user_id
  end
end
