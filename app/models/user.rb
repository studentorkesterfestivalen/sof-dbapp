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
end
