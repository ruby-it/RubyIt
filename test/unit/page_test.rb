require 'test_helper'

class PageTest < Test::Unit::TestCase

  def test_new_create_destroy
    assert_equal pages(:home_page), p=Page.find(1)
    assert p.destroy 
    for p in Page.find :all
      p.destroy
    end

    assert p.destroy
    assert_equal [], Page.find(:all)
  end
  def setup
    Page.find(:all).each do |p|
      p.current_revision.save
    end
  end

  def txest_find_backlinks
    assert cats=pages(:pretty_cats)
    assert_equal 2, cats.backlinks.size
    assert cool=pages(:coolness)
    assert_equal 0, cool.backlinks.size
  end

  def texst_add_backlinks
    assert cats=pages(:pretty_cats)
    assert page=Page.new
    assert r=Revision.new(
      :author=>Author.find_or_create_by_name_and_ip('nome','ip'),
      :body => "[[Pretty cats]] goo bar baz")
    page.current_revision=r
    assert r.save
    assert_equal 3,cats.backlinks.size
  end
  def tesxt_remove_backlinks
    assert cats=pages(:pretty_cats)
    assert home=pages(:home_page)
    assert r=Revision.new(
        :author=>Author.find_or_create_by_name_and_ip('nome','ip'),
        :body=>"no pretty cats")
    home.current_revision=r
    assert r.save
    assert_equal 1, cats.backlinks.size
  end
end
