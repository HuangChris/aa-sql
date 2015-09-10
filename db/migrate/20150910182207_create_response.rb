class CreateResponse < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.timestamps
      t.integer :user_id, null: false
      t.integer :choice_id, null: false
    end
    add_index :responses, [:user_id, :choice_id], unique: true
    add_index :responses, :choice_id
  end
end
