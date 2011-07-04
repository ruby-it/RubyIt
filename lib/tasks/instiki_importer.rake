desc "Import .textile pages in app_dir/import (from Instiki textile export)"
task :instiki_import => :environment do
  book = Book.find(ENV["BOOK_ID"] || 1)
  import_author = Author.create :name => "Instiki Importer", :ip => "127.0.0.1"
  
  FileList["#{ENV["IMPORT_DIR"] || "import"}/*.textile"].each do |m|
    name = File.basename(m,'.textile')
    title = "#{convert_wiki_words(name).gsub(/\[/,'').gsub(/\]/,'')}"
    puts "Importing #{m} as #{title}..."
    
    content = File.read(m)

    if content.strip.empty?
      puts "Skipped empty!"
      next
    end
    
    Book.transaction do
      page    = book.find_or_create_page(:title => title)
      version = page.versions.build(:body => convert_wiki_words(content))
      version.author = import_author
      version.save
    end
  end
end

def convert_wiki_words(str)
  str = str.gsub(/(^|[^\\\S])((?:[[:upper:]][[:lower:]]+)([[:upper:]]+)(?:[[:upper:]]*[[:lower:]]*)+)/) do
    "#{$1}[[#{$2}]]" 
  end
  # convert [[[[Bla blah]]|some text]]
  str.gsub(/\[\[\[\[/,'[[').gsub(/\]\]\|/,'|')
end