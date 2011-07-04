class Author < ActiveRecord::Base
  has_many :revisions

  validates_presence_of :name
  validates_presence_of :ip

  def to_param
    name
  end
end
