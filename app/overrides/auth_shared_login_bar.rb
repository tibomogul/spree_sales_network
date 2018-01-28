# This override is just copied from spree_auth_devise, to remove the warning 2018-01-28
Deface::Override.new(virtual_path: "spree/shared/_nav_bar",
                     name: "auth_shared_login_bar",
                     insert_before: "li#search-bar",
                     partial: "spree/shared/login_bar",
                     disabled: false,
                     original: 'cffbc4624b8c70d8a36b2ce8b915c4b011d1995a')