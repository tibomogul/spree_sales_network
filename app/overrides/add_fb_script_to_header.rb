# This override is just copied from spree_social_products, to remove the warning 2018-01-28
Deface::Override.new(
  virtual_path: 'spree/layouts/spree_application',
  name: 'add_fb_script_to_header',
  insert_bottom: "[data-hook='inside_head']",
  partial: 'spree/shared/fb_script'
)