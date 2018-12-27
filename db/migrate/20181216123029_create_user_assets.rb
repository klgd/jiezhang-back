class CreateUserAssets < ActiveRecord::Migration[5.1]
  def change
    create_table :user_assets do |t|
      t.string :path
      t.string :type
      t.references :imageable, polymorphic: true, index: true
      t.integer :score

      t.timestamps
    end
  end
end
