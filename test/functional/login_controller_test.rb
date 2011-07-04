require 'test_helper'

# Re-raise errors caught by the controller.
class LoginController; def rescue_action(e) raise e end; end

class LoginControllerTest < Test::Unit::TestCase
  def setup
    @controller = LoginController.new
    # mighty hack due to being unable to assign to flash['answer'] 
    # before get'ing a page
    def @controller.answer_ok?
      params['answer']=='risposta'
    end 
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # FIXME: this stuff seem to work,
  # the wiki seem to work, yet tests are broken
  # if you try invalid data or checking cooki settings 
  def test_login_no_data
    get 'index'
    assert assigns['question']
    assert_response :success
    assert flash['answer']
  end
  def test_login_with_valid_input
    # get action paramvars sessionvars flashvars
    name="NomeUtente"
    get 'index',
         {:answer=>'risposta',  :name=>name},
         {},
         {:answer=>'risposta'}
    assert session['authenticated']
    # FIXME: this works, cookies['key'] in tests
    # returns an array
    # but why does it do this?
    # Aand guess what, cookies is undocumented, eh
    assert_equal [name], cookies['author_name']
    assert_response :redirect
  end
    
end
