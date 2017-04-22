class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :user
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  belongs_to :gifted_by, class_name: 'User', foreign_key: 'gifted_by_id'

  def has_owner?(some_user)
    some_user == owner
  end

  def has_member?(member)
    member == user or member == owner
  end
end
