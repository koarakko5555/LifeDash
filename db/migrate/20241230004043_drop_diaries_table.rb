class DropDiariesTable < ActiveRecord::Migration[7.0]
  def change
    drop_table :diaries
  end
end
