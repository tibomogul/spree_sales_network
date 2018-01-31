module Spree
  class Commission < Spree::Base
    belongs_to :order
    belongs_to :user

    def self.create_commissions order
      create(compute_from_order(order))
    end

    def self.compute_from_order order
      payout_results = []
      payout_base = order_payout_base order
      { 
        10.0 => order.user&.parent,
        5.0  => order.user&.parent&.parent,
        1.0  => order.user&.parent&.parent&.parent
      }.each do |k,v|
        unless v.nil?
          amount = (payout_base.to_f * k / 100.0).round(2).to_d
          payout_results << {user: v, order: order, amount: amount}
        end
      end
      payout_results
    end

    def self.order_payout_base order
      order.line_items.to_a.sum(&:total)
    end
  end
end