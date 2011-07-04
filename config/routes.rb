RubyIt::Application.routes.draw do
  root :to => 'home#index'

  match 'pages/:page_title/revisions/new/:revision_number' => 'revisions#new', :constraints => {:revision_number => /\d+/}, :as => :rollback
  match 'pages/:page_title/revisions/new' => 'revisions#new', :as => :new
  match 'pages/:page_title/revisions/:revision_number' => 'revisions#show', :constraints => {:revision_number => /\d+/}, :as => :revision

  #FIXME: something is useless, cleanup
  # menu items, actually
  get 'recent' => 'pages#recent'
  get 'pages/index' => 'pages#index', :as => :pages
  get 'home' => 'home#index'
  get 'pages/all' => 'pages#all', :as => :all_pages
  get 'sitemap' => 'pages#sitemap', :as => :sitemap_top
  get 'pages/sitemap' => 'pages#sitemap', :as => :sitemap
  match 'pages/:page_title' => 'pages#show', :as => :page
  match 'feed.rss' => 'pages#feed', :as => :feed

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  match ':controller(/:action(/:id(.:format)))'
end
