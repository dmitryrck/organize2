class CreateOfxFiles < ActiveRecord::Migration[6.0]
  def change
    create_table :ofx_files do |t|
      t.string :description
      t.text :content, null: false
      t.timestamps null: false
    end
  end
end
