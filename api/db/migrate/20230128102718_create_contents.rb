class CreateContents < ActiveRecord::Migration[7.0]
  def change
    create_table :contents do |t|
      t.belongs_to :document, null: false, foreign_key: true
      t.text :text, null: true

      t.timestamps
    end
  end
end
