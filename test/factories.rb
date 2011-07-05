# common sequences

Factory.sequence :title do |n|
  "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua".split(' ').shuffle.sample(8).join(' ')
end

Factory.sequence :body do |n|
  "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum".split(' ').shuffle.sample(30).join(' ')
end

Factory.sequence :name do |n|
  "person#{n}"
end


# models

Factory.define :author do |a|
  a.name { Factory.next(:name) }
  a.ip { '192.168.1.1' }
end

Factory.define :page do |p|
  p.title { Factory.next :title }
end

Factory.define :revision do |r|
  r.body { Factory.next :body }
  r.association :page
  r.association :author #, :factory => :author
end
