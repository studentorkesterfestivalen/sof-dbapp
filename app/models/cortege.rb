class Cortege < ApplicationRecord
  belongs_to :user
  has_many :members, class_name: 'User', through: :cortege_memberships

  def has_owner?(owner)
    user == owner
  end

  def has_member?(member)
    members.include?(member)
  end

end
