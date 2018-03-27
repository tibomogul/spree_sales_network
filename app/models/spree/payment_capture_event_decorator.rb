Spree::PaymentCaptureEvent.class_eval do
  # has_many :commissions

  set_callback :create, :after, :create_commissions

  def create_commissions
    order = payment.order
    Spree::Commission.create_commissions order, self
  end
end