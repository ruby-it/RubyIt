require 'test_helper'

class RevisionTest < Test::Unit::TestCase

  def setup
    @page = Factory.create(:page)
    @author = Factory.create(:author)
  end

  def test_validations
    revision = Factory.build(:revision, :page => @page, :author => @author)

    # page
    revision.page = nil
    assert !revision.valid?
    assert revision.errors.has_key?(:page)
    revision.page = @page
    assert revision.valid?

    # author
    revision.author = nil
    assert !revision.valid?
    assert revision.errors.has_key?(:author)
    revision.author = @author
    assert revision.valid?

    # body
    body = revision.body
    revision.body = nil
    assert !revision.valid?
    assert revision.errors.has_key?(:body)
    revision.body = body
    assert revision.valid?
  end

  def test_page_links
    revision = Factory.create(:revision, :body => "My fine cats: [[Meow]], [[Kitty]], [[James]]")
    assert_equal %w(Meow Kitty James), revision.page_links
  end

  def test_updating_of_page
    updated_at_before = @page.updated_at
    sleep 0.1 # sleep enough to get different timestamp on updated_at
    revision = @page.revisions.create(
      :author => @author,
      :body => 'this is a body'
    )
    @page.reload
    assert (updated_at_before != @page.updated_at)
  end

  def test_updating_of_page_fail
    updated_at_before = @page.updated_at
    @page.revisions.create(:body => "Lovely voices!")
    assert updated_at_before == @page.updated_at
  end
end
