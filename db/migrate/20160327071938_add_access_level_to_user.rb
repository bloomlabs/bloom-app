class AddAccessLevelToUser < ActiveRecord::Migration
  def up
    add_column :users, :access_level, :integer, default: 0

    User.find_each do |user|
      if user.read_attribute(:staff)
        user.access_level = 100
        user.save!
      end
    end
  end
end
