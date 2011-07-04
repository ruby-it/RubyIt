require 'test_helper'

class AuthorTest < Test::Unit::TestCase
  def setup
    @author = Author.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Author,  @author
  end
  def test_find_or_create
    david1=Author.find_by_name 'David'
    david2=Author.find_or_create_by_name_and_ip 'David','0.0.0.0'
    assert_equal david2, david1
    none=Author.find_by_name 'non esiste'
    assert_nil none
    
    none1=Author.find_or_create_by_name_and_ip 'non esiste','1.2.3.4'
    none2=Author.find_by_name 'non esiste'
    assert_equal none2, none1

  end


end
