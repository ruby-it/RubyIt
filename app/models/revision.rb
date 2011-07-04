class Revision < ActiveRecord::Base
  PAGE_LINK = /\[\[([^\]|]*)[|]?([^\]]*)\]\]/

  belongs_to :page
  belongs_to :author

  after_save  :page_was_updated
  validates_presence_of :author,:body, :page
  validates_associated :author

  def page_links
    @page_links ||= body.scan(PAGE_LINK).map{|k,v| k }
  end

  def code
    body.scan(%r|<pre.*?>\w*(?:<code>)?(.*?)(?:</code>)?\w*</pre>|m).join
  end

  def excerpt(length=300)
    res=""
    in_tag=false
    body.each_line do |line|
      res+=line
      case line
      when /^\s*<pre>/
        in_tag=true
        next
      when /^\s*<\/pre>/
        in_tag=false
      end
      next if in_tag

      break if res.size > length
    end
    res
  end

  def newer_revisions
    @newer_revisions ||= revisions[revision_index + 1..-1]
  end

  def newer_revisions?
    !newer_revisions.empty?
  end

  def older_revisions
    @older_revisions ||= revisions[0...revision_index].reverse
  end

  def older_revisions?
    !older_revisions.empty?
  end

  def previous_revision
    @previous_revision ||= older_revisions.first
  end

  def revisions
    page.revisions
  end

  def number
    revision_index + 1
  end

  protected
  def revision_index
    revisions.index(self)
  end

  def page_was_updated
    page.save
  end
end
