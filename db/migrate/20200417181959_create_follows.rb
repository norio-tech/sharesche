class CreateFollows < ActiveRecord::Migration[5.2]
  def change
    create_table :follows do |t|
      t.integer :user_id
      t.integer :schedule_id
      t.string :schedule_chkdig
      t.string :schedule_sharesche_key
      t.timestamps
    end
  end
end
