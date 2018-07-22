class AddStoreCreditIdToSpreeCommissions < ActiveRecord::Migration[5.1]
  def change
    add_column :spree_commissions, :store_credit_id, :integer
    add_index :spree_commissions, :store_credit_id
    reversible do |dir|
      dir.up do
        type = Spree::StoreCreditType.find_or_create_by(name: 'Points', priority: 10)
        Spree::StoreCreditCategory.find_or_create_by(name: "Points")
      end
      dir.down do
        Spree::StoreCreditType.find_by(name: 'Points', priority: 10).try(&:destroy)
        Spree::StoreCreditCategory.find_by(name: "Points").try(&:destroy)
      end
    end
  end
end
