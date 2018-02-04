Spree::UsersController.class_eval do
  # Original found in spree_auth_devise

  def show
    @orders = @user.orders.complete.order('completed_at desc')
    @commissions = @user.commissions.order('created_at desc')
    @d3_json = to_d3_json @user
  end

  private
  def to_d3_json user, level=3
    ActiveSupport::JSON.encode to_d3_node(user, level)
  end

  def to_d3_node user, level
    raise 'argument error' if level < 0
    level -= 1
    obj = {}
    obj[:name] = user.email
    obj[:size] = 1 + user.children.count
    if user.children.count > 0 && level >= 0
      obj[:children] = []
      user.children.each do |child|
        obj[:children] << to_d3_node(child, level)
      end
    end
    obj
  end
end