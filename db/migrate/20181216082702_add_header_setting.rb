class AddHeaderSetting < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :header_position_1, :string
    add_column :users, :header_position_2, :string
    add_column :users, :header_position_3, :string
    User.find_each do |user|
      user.update_attributes(
        header_position_1: User::POSITION_1[0][:value],
        header_position_2: User::POSITION_2[2][:value],
        header_position_3: User::POSITION_3.last[:value]
      )
    end

  end
end
