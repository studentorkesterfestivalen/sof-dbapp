class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :confirmable, :omniauthable
  include DeviseTokenAuth::Concerns::User

  validate :liu_accounts_must_use_cas

  def liu_accounts_must_use_cas
    if provider != 'cas' and email.end_with? '@student.liu.se'
      errors[:base] << I18n.t('errors.messages.must_use_cas')
    end
  end
end
