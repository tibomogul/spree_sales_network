module Spree
  class Encashment < Spree::Base
    belongs_to :user
    # belongs_to :remittance
    
    state_machine :state, initial: :draft do
      event :authorize do
        transition [:draft, :held] => :authorized
      end

      event :pay do
        transition [:authorized] => :paid
      end

      event :hold do
        transition [:draft, :authorized, :held] => :held
      end

      event :cancel do
        transition all - :paid => :canceled
      end
    end
  end
end