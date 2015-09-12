class CreateQuestion < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.timestamps
      t.integer :poll_id, null: false
      t.text :question_text, null: false
    end
    add_index :questions, :poll_id
  end
end
