require 'test_helper'

# Re-raise errors caught by the controller.
class RevisionsController; def rescue_action(e) raise e end; end

class RevisionsControllerTest < Test::Unit::TestCase
  def setup
    @controller = RevisionsController.new  
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_create_existing_author
    assert_nil Page.find_by_title("A brave new world")
    authorname='David'
    post(
      :create, 
      {
        :page => { :title => "A brave new world" }, 
        :revision => { :body => "So wonderful!" }
      },
      { #session vars
        "authenticated" => true,
        "author_name" =>   authorname
      },
      {# flashvars 
      }    
    )
    assert_equal session['author_name'],authorname
    assert_response :redirect

    page=Page.find_by_title("A brave new world")
    assert_not_nil page, "page nil, it was not saved"
    assert_not_nil  page.current_revision  , "revision nil it was not saved"

    assert_equal "So wonderful!", page.revisions.first.body
    assert_equal authors(:david), page.revisions.first.author
  end

  def test_create_new_author
    assert_nil Page.find_by_title("A brave new world")

    authorname="Some new AuthorName"
    post(
      :create, 
      { #params
        :page => { :title => "A brave new world" }, 
        :revision => { :body => "So wonderful!" }
      },
      { #session vars
        "authenticated" => true,
        "author_name" =>   authorname
      },
      {# flashvars }
      }    
    )
    assert_response :redirect
    assert_equal session['author_name'],authorname
    
    page=Page.find_by_title("A brave new world")
    author= Author.find_by_name  authorname
    
    assert_not_nil page
    assert_not_nil author
    assert_not_nil page.current_revision  
    
    assert_equal "So wonderful!", page.revisions.first.body
    assert_equal author, page.revisions.first.author
  end

  # FIXME: ok, actually testing too much stuff, maybe
  def test_show_old
    title= "some random title"+rand.to_s+rand.to_s
    page=Page.new :title=>title
    assert page.save
    for i in 0..3
      a=Author.find :first
      r=page.revisions.build(:body=>i.to_s)
      r.author=a
      assert r.save, r.errors.full_messages.join("\n")
    end
    assert_equal 4, Page.find_by_title(title).revisions.size
    get :show, {:page_title=>page.title,:revision_number=>1}
    assert_template "revisions/show"
    assert_tag :tag=>'a', :content=>"Forward in time"

    get :show, {:page_title=>page.title,:revision_number=>2}
    assert_tag :tag=>'a', :content=>"Back in time"
  end
  def test_new_no_auth
    get :new ,{:page_title=>'some title', :revision_number=>1}
    assert_response :redirect
  end
  def test_new_auth
    get :new ,
        {:page_title=>'some title', :revision_number=>1},
        {"authenticated"=>true, "author_name"=>'pippo'}
    assert_response 200
    assert_template 'new'
  end
end
