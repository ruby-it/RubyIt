require 'redcloth'
require 'syntax/convertors/html'
class QbCloth < RedCloth
   def initialize(text, existing_wiki_pages, rails_helper)
      super(text)
      @existing_wiki_pages = existing_wiki_pages
      @rails_helper = rails_helper
   end

  Convertor = Syntax::Convertors::HTML.for_syntax "ruby"
  # uglyish hack, we unescape previously escaped stuff
  def smooth_offtags text
    unless @pre_list.empty?
      ## replace <pre> content
     text.gsub!( /<redpre#(\d+)>/ ) do
        
        pretext= @pre_list[$1.to_i]
        pretext=pretext.gsub /&gt;/, ">"
        pretext=pretext.gsub /&lt;/, "<"
        #vim gets confused if we avoid /x :(
        pretext=pretext.gsub /x% x % /x, "&"
        pretag=pretext[/^.*?>/]
        pretext[/^.*?>/]=""
        pretag+Convertor.convert(pretext,false)
     end
    end
  end
  def refs_auto_link(text)
     @rails_helper.auto_link(text, @existing_wiki_pages)
  end
  def refs_insert_wiki_links(text)
    # p "calling refs_insert"
     text.gsub!(Revision::PAGE_LINK) do |m|
       page = title = $1
       title = $2 unless $2.empty?
       if @existing_wiki_pages.include?(page)
         @rails_helper.link_to(title, @rails_helper.page_url(:page_title => page), :class => "existingWikiWord")
       else
         @rails_helper.content_tag("span", title + @rails_helper.link_to("?", @rails_helper.page_url(:page_title => page)), :class => "newWikiWord")
       end
     end
  end
  def refs_textile(text)
    #nop
    text
  end
  def inline_textile_link( text ) 
    text.gsub!( LINK_RE ) do |m|
      pre,atts,text,title,url,slash,post = $~[1..7]
        url, url_title = check_refs( url )
        title ||= url_title
        atts = pba( atts )
        atts = " href=\"#{ url }#{ slash }\"#{ atts }"
        atts << " title=\"#{ title }\"" if title
        atts << " class=\"external\""
        atts = shelve( atts ) if atts
        "#{ pre }<a#{ atts }>#{ text }</a>#{ post }"
    end
  end
    
  def to_html
     super *(DEFAULT_RULES+[:refs_auto_link, :refs_insert_wiki_links])
  end
end
