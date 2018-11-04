class CreateSpreeEncashments < ActiveRecord::Migration[5.1]
  def change
    create_table :spree_encashments do |t|
      t.integer :user_id
      t.decimal :amount, precision: 10, scale: 2
      t.string :state
      t.integer :remittance_id

      t.timestamps null: false
    end
    add_index :spree_encashments, :user_id
    add_index :spree_encashments, :state
    add_index :spree_encashments, :remittance_id
  end
end
