Deface::Override.new(virtual_path: 'spree/users/show',
  name: 'add_sales_network_to_user_show',
  insert_after: 'div.account-my-orders',
  partial: 'spree/shared/my_network' )