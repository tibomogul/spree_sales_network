class AddStateToSpreeCommission < ActiveRecord::Migration[5.1]
  class FauxCommission < ActiveRecord::Base
    # https://coderwall.com/p/zav1dg/using-models-in-rails-migrations
    # https://blog.makandra.com/2010/03/how-to-use-models-in-your-migrations-without-killing-kittens/
    # http://guides.rubyonrails.org/v3.2.8/migrations.html#using-models-in-your-migrations
    self.table_name = 'spree_commissions'
  end
  def change
    add_column :spree_commissions, :state, :string
    add_index :spree_commissions, :state
    reversible do |dir|
      dir.up do
        FauxCommission.reset_column_information
        FauxCommission.update_all state: 'eligible'
      end
      dir.down do
        # nothing really
      end
    end
  end
end
