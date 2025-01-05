class CreateTodos < ActiveRecord::Migration[7.0]
  def change
    create_table :todos do |t|
      t.string :title
      t.text :description
      t.date :deadline
      t.boolean :status

      t.timestamps
    end
  end
end
