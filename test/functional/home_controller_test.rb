require 'test_helper'

# Re-raise errors caught by the controller.
class HomeController; def rescue_action(e) raise e end; end

class HomeControllerTest < Test::Unit::TestCase
  def setup
    @controller = HomeController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  #FIXME: should test the presence of some news
  def test_news
    get 'index'
    assert_tag :tag=>'div', :attributes=>{:class=>'newsitem'}
    assert_tag :tag=>'div', :attributes=>{:id=>'newsbar'}
  end
  def test_side
    get 'index'
    assert_tag :tag=>'div', :attributes=>{:class=>'sideitem'}
    assert_tag :tag=>'div', :attributes=>{:id=>'sidebar'}
  end
  def test_little_stuff
    get 'index'
    assert_tag :ancestor=>{:tag=>'div', :attributes=>{:id => 'sidebar' }},
               :tag => 'a', :content=>'Wiki'
  end
  #FIXME: refactor to generale testcase
  def test_navbar
    get 'index'
    tag={:tag=>'li'}
    assert_tag :ancestor=>tag,
               :tag => 'a', :content=>'Feed'
    
    assert_tag :ancestor=>tag,
               :tag => 'form', :attributes=>{:action=>/google/}
  end
end
