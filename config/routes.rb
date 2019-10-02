Spree::Core::Engine.add_routes do
  get ':sponsor/recommends/:id', to: 'products#show', as: 'recommends'
  # Add your extension routes here
  namespace :admin, path: Spree.admin_path do
    resources :commissions

    resources :encashments, except: [:show] do
      member do
        put :authorize
        put :pay
        put :cancel
        put :hold
    
    resources :reports, only: [:index] do
      collection do
        get :paypal_payment_report
        post :paypal_payment_report
      end
    end
  end

  

end
