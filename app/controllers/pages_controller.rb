class PagesController < ApplicationController
  CODE_HEADER=<<Eot
#!/usr/bin/env ruby
# This code comes from %s
# Check the page for copyright notice and explanations

Eot

  caches_action :show,:feed,:sitemap,:recent,:index
  cache_sweeper :page_sweeper

  def show
    unless @page = Page.find_by_title(params[:page_title]) and (@page.current_revision != nil)
      redirect_to(new_url(:page_title => params[:page_title]))
    end
  end

  def feed
    headers["Content-Type"] = "text/xml"
    render :layout => false
  end

  def sitemap
    @pages=Page.find_all
    render :layout => false
  end

  def index
    @page= Page.find_by_title("Wiki")
    render :action=>:show
  end

  def code
    # FIXME: add better url?
    title=params[:id]
    @page=Page.find_by_title(title)
    headers["Content-Type"] = "text/plain"
    render :text => CODE_HEADER%url_for(:action=>'show',:page_title=>title)+"\n"+@page.code
  end
end
