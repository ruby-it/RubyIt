class RebuildExistingTables < ActiveRecord::Migration
  def self.up

    # Authors
    create_table :authors do |t|
      t.string :name
      t.string :ip
    end

    # Backlinks
    create_table :backlinks, :id => false, :primary_key => [:page_id, :connected_page_id] do |t|
      t.integer :page_id
      t.integer :connected_page_id
    end

    # Pages
    create_table :pages do |t|
      t.string :title
      t.timestamps
    end

    # Revisions
    create_table :revisions do |t|
      t.integer :page_id
      t.integer :author_id
      t.text :body
      t.timestamps
    end
  end

  def self.down
    drop_table :authors
    drop_table :backlinks
    drop_table :pages
    drop_table :revisions
  end
end
