Rails.application.routes.draw do

  match '/herrin', to: 'admin_pages#adm_login_form', via: 'get'
  post 'admin_pages/adm_login'
  post 'admin_pages/adm_logout'
  get 'admin_pages/home'
  match 'admin_pages/adm_upload_selected', to: 'admin_pages#adm_upload_selected', via: 'post', as: 'adm_upload_selected'
  # match 'admin_pages/adm_rm_file/:name', to: 'admin_pages#rm_uploaded_file', via: :delete, as: 'adm_rm_file'
  match 'admin_pages/adm_rm_file' , to: 'admin_pages#rm_uploaded_file', via: :delete, as: 'adm_rm_file' # Pass file name via query string
  # match 'admin_pages/adm_toggle_fileact', to: 'admin_pages#toggle_file_act', via: :post, as: 'adm_toggle_act'

  resources :tags
  resources :userpages

  get 'fixed_static_pages/home'
  get 'fixed_static_pages/contact'


  root 'fixed_static_pages#home'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
