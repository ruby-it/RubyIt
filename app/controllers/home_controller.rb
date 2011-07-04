class HomeController < ApplicationController
  caches_action :index
  cache_sweeper :page_sweeper

  def index
    # FIXME:
    # this is needed for conditional stuff.. better to refactor
    # conditional with polymorphism
    @home=true
    # needed for menu since home is special cased
    @title= "Home"

    # actual logic
    @pages=Page.latest_news(8)
  end
end
