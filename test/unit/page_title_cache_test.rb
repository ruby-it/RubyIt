require 'test_helper'

class PageTitleCacheTest < Test::Unit::TestCase

  def test_title_caching
    #FIXME: does not really work ATM, should check both w w/o refresh
    page = Page.create(:title => "Mistakes we make")

    assert Page.existing_page_titles.include?("Mistakes we make")
        
    page.destroy
    #FIXME: this should remain in the cache
    assert (not Page.existing_page_titles.include?("Mistakes we make"))
  end
end
