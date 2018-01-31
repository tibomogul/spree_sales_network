require 'spec_helper'
require 'byebug'

describe Spree::Commission do
  describe "Spree#compute_from_order" do
    let(:sponsor3) { create(:user) }
    let(:sponsor2) { create(:user, parent: sponsor3) }
    let(:sponsor1) { create(:user, parent: sponsor2) }
    let(:user) { create(:user, parent: sponsor1) }

    describe "one line_item 1 qty for 10" do
      let(:order) { create(:order_with_line_items, user: user) }

      it "expects to compute comissions from the order" do
        payouts = Spree::Commission.compute_from_order order
        price = order.line_items.to_a.sum(&:total)
        expect(payouts.count).to eq(3)
        expect(payouts[0]).to eq({user: sponsor1, order: order, amount: (price*0.10).to_d.round(2)})
        expect(payouts[1]).to eq({user: sponsor2, order: order, amount: (price*0.05).to_d.round(2)})
        expect(payouts[2]).to eq({user: sponsor3, order: order, amount: (price*0.01).to_d.round(2)})
      end
    end

    describe "one line_item 5 qty for 50" do
      let(:order) { create(:order_with_line_item_quantity, user: user,
        line_items_price: BigDecimal.new(50), line_items_quantity: 5) }

      it "expects to compute comissions from the order" do
        payouts = Spree::Commission.compute_from_order order
        expect(payouts.count).to eq(3)
        expect(payouts[0]).to eq({user: sponsor1, order: order, amount: 25 })
        expect(payouts[1]).to eq({user: sponsor2, order: order, amount: 12.5 })
        expect(payouts[2]).to eq({user: sponsor3, order: order, amount: 2.5 })
      end
    end

    describe "one line_item 1 qty for 19.99" do
      let(:order) { create(:order_with_line_item_quantity, user: user,
        line_items_price: '19.99', line_items_quantity: 1) }

      it "expects to compute comissions from the order" do
        payouts = Spree::Commission.compute_from_order order
        expect(payouts.count).to eq(3)
        expect(order.line_items.sum(&:total)).to eq(19.99)
        expect(payouts[0]).to eq({user: sponsor1, order: order, amount: 2 })
        expect(payouts[1]).to eq({user: sponsor2, order: order, amount: 1 })
        expect(payouts[2]).to eq({user: sponsor3, order: order, amount: 0.20 })
      end
    end

    describe "one line_item 1 qty for 19.50" do
      let(:order) { create(:order_with_line_item_quantity, user: user,
        line_items_price: '19.50', line_items_quantity: 1) }

      it "expects to compute comissions from the order" do
        payouts = Spree::Commission.compute_from_order order
        expect(payouts.count).to eq(3)
        expect(order.line_items.sum(&:total)).to eq(19.50)
        expect(payouts[0]).to eq({user: sponsor1, order: order, amount: 1.95 })
        expect(payouts[1]).to eq({user: sponsor2, order: order, amount: 0.98 })
        expect(payouts[2]).to eq({user: sponsor3, order: order, amount: 0.20 })
      end
    end
  end
end