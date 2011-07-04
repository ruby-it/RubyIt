require 'test_helper'
# require 'lib/qbcloth'

Mock_helper = Object.new 
for i in [:auto_link, :link_to, :page_url, :content_tag]
  eval %{def Mock_helper.#{i}(*args) "#{i}(%s)"%args end}
end

class TC_QbCloth < Test::Unit::TestCase
  def qb(str,ary=[])
    QbCloth.new str, ary, Mock_helper

  end
  def assert_html(html, qb,msg=nil)
    assert_equal html, qb.to_html, msg
  end
  def test_escaping
    t= <<-Eof
        this < > & has to be escaped
        while this should be highlighted
        <pre>
          <
          >
          &
        </pre>
    Eof
    html= qb(t).to_html
    assert_equal "&lt; &gt; &#38;",html[5,15]
    span="<span.*?&%s;.*?</span>"
    for i in %w{gt lt amp}
      assert html[/#{span%i}/], "missing #{i}"
    end
  end
  def test_object_repr_in_pre
    assert_html "<pre> <span class=\"comment\">#&lt;Object&gt; </span></pre>",
      qb("<pre> #<Object> </pre>")
  end

  def test_single_wiki_link
    assert_html  "<p>link_to(linkname)</p>",           
      qb("[[linkname]]",%w[linkname]), 
      "a single link on a line is swallowed"
  end

  def test_wiki_link
    assert_html  "<p>Foo link_to(link) <strong>bar</strong></p>",            
      qb("Foo [[link]] *bar*",%w[link]) 
  end
  def test_external_wiki_link
    assert_html %(<p>foo <a href="http://foo" class="external">bar</a></p>),
      qb(%[foo "bar":http://foo])
  end
end
