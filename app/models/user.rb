require 'kobra'

class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :confirmable, :omniauthable
  include DeviseTokenAuth::Concerns::User
  include UserPermissionConcern

  has_many :orchestras
  has_many :orchestra_signups

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

  def is_lintek_member?
    return false if provider != 'cas'

    begin
      kobra = Kobra::Client.new(api_key: Rails.configuration.kobra_api_key)
      response = kobra.get_student(id: nickname, union: true)

      return response[:union] == 'LinTek'
    rescue
      return false
    end
  end
end
