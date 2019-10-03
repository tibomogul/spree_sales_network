module Spree
  class Encashment < Spree::Base
    include Spree::Commission::Calculator
    include Spree::Commission::PayOut

    AUTHORIZE_ACTION = 'authorize'.freeze
    PAY_ACTION = 'pay'.freeze
    HOLD_ACTION = 'hold'.freeze
    CANCEL_ACTION = 'cancel'.freeze

    belongs_to :user
    # belongs_to :remittance
    
    attr_accessor :action, :action_amount

    extend DisplayMoney
    money_methods :amount, :amount_used

    state_machine :state, initial: :draft do
      before_transition :on => :authorize, :do => :authorize_action_items
      before_transition :on => :pay, :do => :pay_action_items


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
        transition all - [:paid, :canceled] => :canceled
      end
    end

    def authorize_action_items
    end

    def pay_action_items
    end

  end
end