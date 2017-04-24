class TransferUnionToGroupPermissions < ActiveRecord::Migration[5.0]
  def change
    User.find_each do |user|
      if user.is_lintek_member
        user.usergroup |= UserGroupPermission::LINTEK_MEMBER
        user.save!
      end
    end
  end
end
