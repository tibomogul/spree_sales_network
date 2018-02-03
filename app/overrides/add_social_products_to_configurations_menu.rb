# This override is just copied from spree_social_products, to remove the warning 2018-01-28
Deface::Override.new(
  virtual_path:  'spree/admin/shared/sub_menu/_configuration',
  name:          'add_social_products_to_configurations_menu',
  insert_bottom: '[data-hook="admin_configurations_sidebar_menu"]',
  text:          '<%= configurations_sidebar_menu_item Spree.t(:settings, scope: :social), edit_admin_social_settings_path %>',
  original:      '28204a1f46d26e6579991e4e85b67317e50458d5'
)