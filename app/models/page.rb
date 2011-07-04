class Page < ActiveRecord::Base

  has_many :revisions, :order => "created_at", :dependent => :delete_all # deleted ->delete all
  has_one  :current_revision, :class_name => "Revision", :order => "created_at DESC"

  def find_or_build_revision(number = nil)
    number ? revisions[number.to_i - 1] : revisions.build(:body => body)
  end

  %w{body author created_at excerpt code}.each do |method|
    define_method "#{method}" do
      current_revision ? current_revision.send("#{method}") : "Prima revisione: inserisci il tuo testo"
    end
  end

  def to_param
    title
  end

  class << self
    def existing_page_titles
      all.map(&:title)
    end

    def latest_news(num = 5)
      where("title != 'Prova'").order('updated_at DESC').limit(num)
    end
  end
end
