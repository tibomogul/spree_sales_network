module Spree
  class Commission < Spree::Base
    module Calculator
      extend ActiveSupport::Concern

      class_methods do
        def create_commissions order
          create!(compute_from_order(order))
        end

        def compute_from_order order
          payout_results = []
          house_rate = 0
          payout_base = order_payout_base order
          { 
            10.0 => order.user&.parent,
            5.0  => order.user&.parent&.parent,
            1.0  => order.user&.parent&.parent&.parent
          }.each do |k,v|
            if v.nil?
              house_rate += k
            else
              amount = (payout_base.to_f * k / 100.0).round(2).to_d
              payout_results << {
                user: v,
                order: order,
                amount: amount,
                rate: k,
                base_price: payout_base
              }
            end
          end
          if house_rate > 0
            amount = (payout_base.to_f * house_rate / 100.0).round(2).to_d
            payout_results << {
              user: nil,
              order: order,
              amount: amount,
              rate: house_rate,
              base_price: payout_base
            }
          end
          payout_results
        end

        def order_payout_base order
          order.item_total + order.adjustments.sum(:amount)
        end      	

        def reduce_commission reimbursement
          return unless reimbursement.customer_return
          reimbursement.order.commissions.each do |commission|
            base_price = commission.base_price - reimbursement.total
            base_price = 0 if base_price < 0.01 # check tolerance
            if base_price > 0
              commission.base_price = base_price
              commission.amount = (base_price * commission.rate / 100.00).round(2).to_d
            else
              commission.base_price = 0
              commission.amount = 0
            end
            commission.save!
          end
        end
      end
  	end
  end
end
