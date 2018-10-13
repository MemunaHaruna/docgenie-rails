class CreateDocuments < ActiveRecord::Migration[5.1]
  def change
    create_table :documents do |t|
      t.string :title
      t.integer :access, default: 0, null: false
      t.text :content
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
