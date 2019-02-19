# require 'kobra'

class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable,
        :registerable,
        :recoverable,
        :rememberable,
        :trackable,
        :validatable,
    #    :confirmable,
        :omniauthable
  include DeviseTokenAuth::Concerns::User



  include UserPermissionConcern




  has_many :orchestra
  has_many :orchestra_signup
  has_one :cortege
  has_one :case_cortege
  has_one :cart
  has_one :cortege_membership
  has_one :funkis_application

  has_many :orders
  has_many :purchased_items, class_name: OrderItem, foreign_key: :user_id
  has_many :owned_items, class_name: OrderItem, foreign_key: :owner_id

  validate :liu_accounts_must_use_cas

  def liu_accounts_must_use_cas
    if provider != 'cas' and not email.nil? and email.end_with? '@student.liu.se'
      errors[:base] << I18n.t('errors.messages.must_use_cas')
    end
  end

  def has_admin_permission?(permission)
    includes_permission?(admin_permissions, permission) or includes_permission?(admin_permissions, AdminPermission::ALL)
  end

  def has_group_permission?(group)
    includes_group_permission?(usergroup, group) or includes_permission?(usergroup, UserGroupPermission::ALL)
  end

  def has_owner?(owner)
    owner == self
  end

  def email
    super || "#{nickname}@student.liu.se"
  end

  def display_name
    if is_liu_student? and super.nil?
      update_display_name
    end

    super
  end

  def union
    #if is_liu_student? and union_valid_thru.past?
    #  update_union
    #end

    super
  end

  #def is_lintek_member
  #  self[:union] == 'LinTek'
  #end

  def cart
    cart = super
    if cart.nil?
      cart = Cart.new

      self.cart = cart
      self.save!
    else
      # TODO: Refactor out this duration to a class variable
      if cart.updated_at < DateTime.now - 12.hours
        cart.empty!
      end
    end

    cart
  end

  def shopping_cart_count
    cart.cart_items.count
  end

  # def update_from_kobra!
  #   return unless is_liu_student?
  #
  #   if self[:display_name].nil?
  #     update_display_name
  #   end
  #
  #   if self[:union].nil? or union_valid_thru.past?
  #     update_union
  #   end
  # end

  def send_evaluation_email
    EvaluationMailer.evaluation(self).deliver_now
  end

  private

  # def update_union
  #   if is_liu_student?
  #     begin
  #       kobra = Kobra::Client.new(api_key: Rails.configuration.kobra_api_key)
  #       response = kobra.get_student(id: nickname, union: true)
  #
  #       self[:union] = response[:union]
  #
  #       if is_lintek_member
  #         self[:usergroup] |= UserGroupPermission::LINTEK_MEMBER
  #         self[:union_valid_thru] = end_of_fiscal_year
  #       else
  #         self[:usergroup] &= ~UserGroupPermission::LINTEK_MEMBER
  #         self[:union_valid_thru] = DateTime.now.at_end_of_day
  #       end
  #
  #       save!
  #     rescue Kobra::Client::NotFound
  #       # Will try again tomorrow
  #       FaultReport.send("Failed to find student in Kobra (id: #{nickname})")
  #       self[:union_valid_thru] = DateTime.now.at_end_of_day
  #     rescue
  #       # Will try again in 10 minutes
  #       FaultReport.send("Failed to update union from Kobra (id: #{nickname})")
  #       self[:union_valid_thru] = DateTime.now + 10.minutes
  #     end
  #   end
  #
  #   save!
  # end

  def update_display_name
       self[:display_name] = self[:uid]
       save!
  end
  #   begin
  #     # kobra = Kobra::Client.new(api_key: Rails.configuration.kobra_api_key)
  #     # response = kobra.get_student(id: nickname)
  #
  #     self[:display_name] = response[:name]
  #     save!
  #   rescue
  #     FaultReport.send("Failed to update name from Kobra (id: #{nickname})")
  #   end
  # end

  def end_of_fiscal_year
    now = DateTime.now
    if now.month >= 7
      DateTime.new(now.year + 1, 6, 30)
    else
      DateTime.new(now.year, 6, 30)
    end
  end

  def is_liu_student?
    provider == 'cas'
  end
end
