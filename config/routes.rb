Spree::Core::Engine.add_routes do
  get 'coming-soon', to: 'home#coming_soon', as: 'coming_soon'
  get 'vida-woman', to: 'home#vida_woman', as: 'vida_woman'
  get ':sponsor/recommends/:id', to: 'products#show', as: 'recommends'
  # Add your extension routes here
  namespace :admin, path: Spree.admin_path do
    resources :commissions
  end
end
