class OrchestraSignup < ApplicationRecord
  LATE_REGISTRATION_START_DATE = Time.utc(2019, 3, 10)

  BIG_PACKAGE   = 500
  SMALL_PACKAGE = 470
  SATURDAY      = 220

  FOOD_TICKET_BIG_PACKAGE   = 240
  FOOD_TICKET_SMALL_PACKAGE = 140
  FOOD_TICKET_SATURDAY      = 75

  DORMITORY = 50

  T_SHIRT = 100
  MEDAL   = 40
  PATCH   = 20

  LATE_REGISTRATION = 300

  belongs_to :orchestra
  belongs_to :user
  has_one :orchestra_ticket
  has_one :orchestra_food_ticket
  has_many :orchestra_articles, dependent: :destroy
  has_many :special_diets, dependent: :destroy

  accepts_nested_attributes_for :orchestra_ticket, :orchestra_food_ticket, :orchestra_articles, :special_diets

  def has_member?(member)
    has_owner? member or orchestra.has_owner? member
  end

  def has_owner?(owner)
    user == owner
  end

  def dormitory
    # Allow dormitory to inherit from orchestra default preference
    value = super
    if value.nil?
      false
    else
      value
    end
  end

  def total_cost
    cost = 0
    cost += ticket_price
    cost += food_ticket_price
    cost += DORMITORY if dormitory
    cost += LATE_REGISTRATION if is_late_registration?

    unless orchestra_articles.nil?
      orchestra_articles.each { |x| cost += article_prices[x.kind] }
    end

    cost
  end

  def ticket_price
    if orchestra_ticket.nil?
      return 0
    end

    prices = [BIG_PACKAGE, SMALL_PACKAGE, SATURDAY, 0]


    prices[orchestra_ticket.kind]
  end

  def food_ticket_price
    if orchestra_food_ticket.nil?
      return 0
    end
      # Stora paketet,
    prices = [FOOD_TICKET_BIG_PACKAGE, FOOD_TICKET_SMALL_PACKAGE, FOOD_TICKET_SATURDAY, 0]
    prices[orchestra_food_ticket.kind]
  end

  def article_prices
    [T_SHIRT, MEDAL, PATCH, 0]
  end

  def self.include_late_registration_fee?
    Time.now >= LATE_REGISTRATION_START_DATE
  end
end
