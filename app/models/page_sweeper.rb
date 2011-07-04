class Sweeper < ActionController::Caching::Sweeper
  def expire_globals
    expire_action :controller=>'home',:action=>'index'
    expire_action :controller=>'pages',:action=>'feed'
    expire_action :controller=>'pages',:action=>'recent'
    expire_action :controller=>'pages',:action=>'sitemap'
  end

  def after_update(page)
    expire_globals
    expire_action :controller=>'pages',:action=>'show',:page_title=>page.title
  end
end

class PageSweeper < Sweeper
  observe Page
  def after_create(page)
    expire_globals
    Page.existing_page_titles.each do |title|
      expire_action :controller=>'pages',:action=>'show',:page_title=>title
    end
  end
end

class RevisionSweeper < Sweeper
  observe Revision
  def after_save(revision)
    expire_globals
    Page.existing_page_titles.each do |title|
      expire_action :controller=>'pages',:action=>'show',:page_title=>title
    end
  end
end

