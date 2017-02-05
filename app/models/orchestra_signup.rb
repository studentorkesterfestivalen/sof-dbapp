class OrchestraSignup < ApplicationRecord
  belongs_to :orchestra
  belongs_to :user
  has_one :orchestra_ticket
  has_one :orchestra_food_ticket
  has_many :orchestra_articles
  has_many :special_diets

  accepts_nested_attributes_for :orchestra_ticket, :orchestra_food_ticket, :orchestra_articles, :special_diets

  def has_member?(member)
    has_owner? member or orchestra.has_owner? member
  end

  def has_owner?(owner)
    user == owner
  end

  def dormitory
    # Allow dormitory to inherit from orchestra default preference
    super || orchestra.dormitory
  end
end
