require 'test_helper'

class RevisionTest < Test::Unit::TestCase
  PageName='qualche lungo titolo'
  def test_page_links
    assert_equal %w(Meow Kitty James), revisions(:pretty_cats_v1).page_links
  end
  
  def test_new
    assert r=Revision.new(
        :author=>Author.find_or_create_by_name_and_ip('nome','ip'),
        :body => "Lovely voices!"
    )
    assert_equal false, r.save
    p= Page.new :title=>PageName
    p.current_revision=r
    assert p.save
    assert_equal Page.find_by_title(PageName).current_revision, r
  end

  def test_create
    assert r=Revision.create(
        :author=>Author.find_or_create_by_name_and_ip('nome','ip'),
        :body => "Lovely voices!"
    )
    assert_kind_of ActiveRecord::Errors, r.errors
    assert_equal "can't be blank", r.errors['page']
    p= Page.new :title=>PageName
    assert r=Revision.create(
        :author=>Author.find_or_create_by_name_and_ip('nome','ip'),
        :body => "Lovely voices!",
        :page => p
    )
    assert_equal Page.find_by_title(PageName).current_revision, r
  end

  def test_updating_of_page
    updated_at_before = pages(:pretty_cats).updated_at
    revision=pages(:pretty_cats).revisions.create(
        :author=>Author.find_or_create_by_name_and_ip('nome','ip'),
        :body => "Lovely voices!"
    )
    #p "--",updated_at_before,updated_at_before,"--"
    assert updated_at_before < pages(:pretty_cats, :refresh).updated_at
  end
  def test_updating_of_page_fail
    updated_at_before = pages(:pretty_cats).updated_at
    pages(:pretty_cats).revisions.create(:body => "Lovely voices!")
    assert updated_at_before == pages(:pretty_cats, :refresh).updated_at
  end
end
