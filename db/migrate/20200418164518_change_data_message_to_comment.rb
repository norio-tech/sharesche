class ChangeDataMessageToComment < ActiveRecord::Migration[5.2]
  def change
    change_column :comments, :message, :text 
  end
end
