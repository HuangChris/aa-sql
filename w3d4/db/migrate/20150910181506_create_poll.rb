class CreatePoll < ActiveRecord::Migration
  def change
    create_table :polls do |t|
      t.timestamps

      t.string :title, null: false
      t.integer :author_id, null: false
    end

    add_index :polls, :author_id, unique: true
  end
end
