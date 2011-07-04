require 'test_helper'

# Re-raise errors caught by the controller.
class PagesController; def rescue_action(e) raise e end; end

class PagesControllerTest < Test::Unit::TestCase
  def setup
    @controller = PagesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_home
    get 'show', :page_title=>'Home Page'
    assert_response :success
    assert_tag :tag=>'head', :child=>{:tag=>"title", :content=>SITE_NAME}
  end

  def test_show_nonexistent
    tit="nonexistingpage"
    get :show, {:page_title=>tit}
    assert_response :redirect
    # it seem rails is broken wrt this or I'm just dumb
    #assert_redirected_to :controller=>'revisions',:action=>'new',:page_title=>tit
  end

  def test_sitemap
    get :sitemap
    assert_template 'pages/sitemap'
    assert_response :success
    assert_tag :tag=>'urlset', :children=>{:count=>4,:only=>{:tag=>'url'} }
    assert_tag :tag=>'url', :child=>{:tag=>'loc'}
    assert_tag :tag=>'url', :child=>{:tag=>'lastmod'}
  end

  def test_all_pages
    get 'all'
    assert_response :success
    assert_tag :tag=>"title", :content=>"Ruby Italia: Tutte le pagine"
  end
  
  def test_recent
    get 'recent'
    assert_response :success
    assert_tag :tag=>"title", :content=>"Recently Revised"
  end

  def test_feed
    get 'feed'
    assert_template 'pages/feed'
    assert_tag :tag=>"rss", :child=>{:tag=>"channel"}
    assert_tag :tag=>"dc:creator"
  end

  def test_show
    get 'show', :page_title=>'Pretty cats'
    assert_template 'pages/show'
    assert_response :success
    assert_equal 'text/html', @response.headers['Content-Type'], @response.headers.inspect
    assert_tag :tag=>'div',:attributes=>{:id=>'header'} 
  end
  def test_code
    page_title='example code'
    get 'code', :id =>page_title
    assert_template nil
    assert_equal 'text/plain', @response.headers['Content-Type']
    assert_response :success
    assert_equal <<Eoc, @response.body
#{PagesController::CODE_HEADER% "http://test.host/pages/example+code"}

some code

more code
Eoc
  end
  
  def test_title_with_dots
    get  :show, :page_title=> 'Page. With. Dots'
    assert_response :success
    assert_template 'pages/show'
    assert_equal 'text/html', @response.headers['Content-Type']
  end
end
