class Taggings < ActiveRecord::Migration
  def change
    create_table :taggings do |t|
      t.timestamps
      t.integer :url_id
      t.integer :tag_topic_id
    end
  end
end
