require 'test_helper'

class AuthorTest < Test::Unit::TestCase

  # validations
  def test_validates_presence_of_name
    author = Factory.build :author, :name => nil
    assert !author.valid?
    assert author.errors.has_key?(:name)

    author.name = 'Pippo'
    assert author.valid?
  end

  def test_validates_presence_of_ip
    author = Factory.build :author, :ip => nil
    assert !author.valid?
    assert author.errors.has_key?(:ip)

    author.ip = '10.0.0.1'
    assert author.valid?
  end
end
