Spree::UsersController.class_eval do
  # Original found in spree_auth_devise

  def show
    @orders = @user.orders.complete.order('completed_at desc')
    @commissions = @user.commissions.order('created_at desc')
  end
end