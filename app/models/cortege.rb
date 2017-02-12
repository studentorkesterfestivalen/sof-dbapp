class Cortege < ApplicationRecord
  belongs_to :user

  def has_owner?(owner)
    user == owner
  end
end
