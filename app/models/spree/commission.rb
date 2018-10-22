module Spree
  class Commission < Spree::Base
    include Spree::Commission::Calculator
    include Spree::Commission::PayOut
    
    belongs_to :order
    belongs_to :user

    extend DisplayMoney
    money_methods :amount, :base_price

    state_machine :state, initial: :eligible do
      event :authorize do
        transition [:eligible, :held] => :authorized
      end

      event :pay do
        transition [:authorized] => :paid
      end

      event :hold do
        transition [:eligible, :authorized, :held] => :held
      end

      event :cancel do
        transition all - :paid => :canceled
      end
    end
  end
end