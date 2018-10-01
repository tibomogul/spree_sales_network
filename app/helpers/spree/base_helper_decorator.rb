module Spree
  BaseHelper.module_eval do
    def product_share_url(product, options={})
      if !product
        if spree_current_user && !spree_current_user.sales_network_slug.blank?
          root_url(sponsor: spree_current_user.sales_network_slug)
        else
          root_url
        end
      elsif spree_current_user && !spree_current_user.sales_network_slug.blank?
        url = spree.recommends_url(product, options.merge(sponsor: spree_current_user.sales_network_slug))
      elsif current_sponsor.present?
        url = spree.recommends_url(product, options.merge(sponsor: current_sponsor))
      else
        url = spree.product_url(product, options)
      end
    end

    def current_sponsor
      session[:sponsor]
    end
  end
end
