Deface::Override.new(virtual_path: 'spree/admin/shared/_main_menu',
  name: 'add_commissions_to_main_menu_sidebar',
  replace: "erb[silent]:contains('if can? :admin, Spree::Order')",
  closing_selector: "erb[silent]:contains('end')",
  text: "
    <% if can? :admin, Spree::Order %>
      <ul class='nav nav-sidebar'>
        <%= main_menu_tree Spree.t(:orders), icon: 'shopping-cart', sub_menu: 'orders', url: '#sidebar-orders' %>
      </ul>
    <% end %>
  ",
  :original => '13940fef6eef46758658f4fdb9cd1f009ede24f3')