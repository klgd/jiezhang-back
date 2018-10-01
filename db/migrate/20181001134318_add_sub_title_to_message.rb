class AddSubTitleToMessage < ActiveRecord::Migration[5.1]
  def change
    add_column :messages, :sub_title, :text
  end
end
