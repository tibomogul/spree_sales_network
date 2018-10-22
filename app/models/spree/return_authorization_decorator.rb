Spree::ReturnAuthorization.class_eval do
  after_create :hold_commissions

  def hold_commissions
    order.commissions.each(&:hold!) if order&.commissions
  end
end