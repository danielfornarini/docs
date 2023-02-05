class CreateUserDocuments < ActiveRecord::Migration[7.0]
  def change
    create_table :user_documents do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :document, null: false, foreign_key: true
      t.integer :permission, null: false
      t.timestamps

      t.index [:user_id, :document_id], unique: true
    end
  end
end
