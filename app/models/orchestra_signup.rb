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

  def total_cost
    cost = 0
    cost += ticket_prices[orchestra_ticket.kind] unless orchestra_ticket.nil?
    cost += food_prices[orchestra_food_ticket.kind] unless orchestra_food_ticket.nil?
    cost += 50 if dormitory?

    unless orchestra_articles.nil?
      orchestra_articles.each { |x| cost += article_prices[x.kind] }
    end

    cost
  end

  def ticket_prices
    if user.is_lintek_member
      [435, 410, 190, 0]
    else
      [535, 510, 220, 0]
    end
  end

  def food_prices
    [215, 140, 75, 0]
  end

  def article_prices
    [0, 100, 40, 20]
  end
end
