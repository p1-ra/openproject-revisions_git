OpenProject::Application.routes.draw do
  # User's own public key management
  scope '/my' do
    resources :public_keys, controller: 'my_public_keys', except: [:edit, :show, :update]
  end

  namespace 'admin' do
    resources :public_keys, controller: 'gitolite_public_keys', except: [:edit, :show, :update]
  end
  
  #The route will have the prefix "projects/:project_id/" plus our controller "manage_git_repository"
  scope 'projects/:project_id' do
    #Rails will create all routes (HTTP method, Path, Controller) if we just use "resources"
    #In this case, we create routes only for "index" and it translates to:
    #"get 'projects/:project_id/manage_git_repositories', :to => 'manage_git_repositories#index'"
    resources :manage_git_repository, controller: 'manage_git_repositories', only: :index

    resources :repository_deployment_credentials, controller: 'repository_deployment_credentials'
    resources :repository_post_receive_urls, controller: 'repository_post_receive_urls'
    get 'repository_mirrors/push', :to => 'repository_mirrors#push'
    resources :repository_mirrors, controller: 'repository_mirrors'
    resources :repository_git_config_keys, controller: 'repository_git_config_keys'
  end
  
  get 'settings/plugin/:id/install_gitolite_hooks', to: 'settings#install_gitolite_hooks', as: 'install_gitolite_hooks'

  # Post Receive Hooks (jbox-web)
  #mount Hrack::Bundle.new({}), at: 'githooks/post-receive/:type/:projectid', via: [:post]

end
