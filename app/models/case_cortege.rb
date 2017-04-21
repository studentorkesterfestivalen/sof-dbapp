class CaseCortege < ApplicationRecord
  belongs_to :user
  has_many :users, through: :cortege_memberships

  def has_owner?(owner)
    user == owner
  end

  def has_member?(member)
    users.include? member
  end
end
