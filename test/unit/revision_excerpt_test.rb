require 'test_helper'

class TC_Excerpt < Test::Unit::TestCase
 def excerpt(t)
    r=Revision.new :body=>t
    r.excerpt
 end
 def assert_expt(word,str)
  assert_equal word, excerpt(str)[-(word.size+1)..-2]
 end
 def test_short_start
    t=<<-Eof
      foo bar baz

      Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Nam liber tempor cum soluta nobis eleifend option congue nihil imperdiet doming id quod mazim placerat facer possim assum. Typi non habent claritatem insitam; est usus legentis in iis qui facit eorum claritatem. Investigationes demonstraverunt lectores legere me lius quod ii legunt saepius. Claritas est etiam processu

      bar baz baz bla bla bla
    Eof
    assert_expt "processu",t
  end
  def test_normal
    t= <<-Eof 
      Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Nam liber tempor cum soluta nobis eleifend option congue nihil imperdiet doming id quod mazim placerat facer possim assum. Typi non habent claritatem insitam; est usus legentis in iis qui facit eorum claritatem. Investigationes demonstraverunt lectores legere me lius quod ii legunt saepius. Claritas est etiam processu

      Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Nam liber tempor cum soluta nobis eleifend option congue nihil imperdiet doming id quod mazim placerat facer possim assum. Typi non habent claritatem insitam; est usus legentis in iis qui facit eorum claritatem. Investigationes demonstraverunt lectores legere me lius quod ii legunt saepius. Claritas est etiam processu
    Eof
    assert_equal "processu",excerpt(t)[-9..-2]
  end
  def test_with_pre_block
    t= <<-Eof
Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. 
<pre>
Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod 
tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, 
quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea 
commodo consequat. 
</pre>
Eof
    assert_expt "</pre>",t
  end
  def test_with_breaks_in_pre_block
    
    t= <<-Eof
Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. 
<pre>
Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod 
tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, 
    
quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea 
commodo consequat. 
</pre>
Eof
    assert_expt "</pre>",t
  end
  def test_short_page
    t= <<-Eof
foo bar baz
<pre>
</pre>
Eof
    assert_expt "</pre>",t
  end
  def test_spaces_after_tag
    t= <<-Eof
foo bar baz
<pre>
bar
</pre>  
Eof
    assert_equal "</pre>  ",excerpt(t)[-9..-2]
  end
  def test_stuff_after_short_pre
    t= <<-Eof
foo bar
<pre>
 baz maiao ma

<pre>
miao miao miao bau baz rmrmel alala
Eof
    assert_expt "alala",t
  end
  def test_strange_stuff_in_pre
    t= <<-Eof
foo bar
<pre>
 baz maiao ma
  <#Foo>
  <Foo>
  </bar>

<pre>
miao miao miao bau baz rmrmel alala
Eof
    assert_expt "alala",t
  end
end
