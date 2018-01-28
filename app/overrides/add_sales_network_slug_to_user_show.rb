Deface::Override.new(virtual_path: 'spree/users/show',
  name: 'add_sales_network_slug_to_user_show',
  insert_after: 'dl#user-info',
  text: "
    <% if @user.sales_network_slug.present? %>
      <dl id='user-network'>
        <dt><%= Spree.t(:sales_network_slug) %></dt>
        <dd><%= @user.sales_network_slug %></dd>
      </dl>
    <% end %>
  ")