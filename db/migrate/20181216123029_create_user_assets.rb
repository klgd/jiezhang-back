class CreateUserAssets < ActiveRecord::Migration[5.1]
  def change
    create_table :user_assets do |t|
      t.integer :user_id
      t.string :path
      t.string :target
      t.integer :target_id
      t.integer :score

      t.timestamps
    end
  end
end
