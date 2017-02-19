require 'kobra'

class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable
  include DeviseTokenAuth::Concerns::User
  include UserPermissionConcern

  has_one :orchestra
  has_one :orchestra_signup
  has_one :cortege
  has_one :case_cortege

  validate :liu_accounts_must_use_cas

  def liu_accounts_must_use_cas
    if provider != 'cas' and not email.nil? and email.end_with? '@student.liu.se'
      errors[:base] << I18n.t('errors.messages.must_use_cas')
    end
  end

  def has_permission?(permission)
    includes_permission?(permissions, permission) or includes_permission?(permissions, Permission::ALL)
  end

  def has_owner?(owner)
    owner == self
  end

  def email
    super || "#{nickname}@student.liu.se"
  end

  def display_name
    if provider == 'cas' and super.nil? and is_compatible_liu_student?
      update_display_name
    end

    super
  end

  def union
    if provider == 'cas' and union_valid_thru.past? and is_compatible_liu_student?
      update_union
    end

    super
  end

  def is_lintek_member
    self[:union] == 'LinTek'
  end

  private

  def update_union
    if provider == 'cas'
      begin
        kobra = Kobra::Client.new(api_key: Rails.configuration.kobra_api_key)
        response = kobra.get_student(id: nickname, union: true)

        self[:union] = response[:union]
        if is_lintek_member
          self[:union_valid_thru] = end_of_fiscal_year
        else
          self[:union_valid_thru] = DateTime.now.at_end_of_day
        end

        save!
      rescue Kobra::Client::NotFound
        puts 'Failed to find student in Kobra, trying again tomorrow'
        self[:union_valid_thru] = DateTime.now.at_end_of_day
      rescue
        puts 'Failed to update union from Kobra, trying again in 10 minutes'
        self[:union_valid_thru] = DateTime.now + 10.minutes
      end
    end

    save!
  end

  def update_display_name
    begin
      kobra = Kobra::Client.new(api_key: Rails.configuration.kobra_api_key)
      response = kobra.get_student(id: nickname)

      self[:display_name] = response[:name]
      save!
    rescue
      puts 'Failed to update name from Kobra'
    end
  end

  def end_of_fiscal_year
    now = DateTime.now
    if now.month >= 7
      DateTime.new(now.year + 1, 6, 30)
    else
      DateTime.new(now.year, 6, 30)
    end
  end

  # Kobra does seem to have any records for students with liu ids shorter than 8 characters,
  # from this assumption we avoid this lookup completely and increase performance
  def is_compatible_liu_student?
    nickname.length >= 8
  end
end
