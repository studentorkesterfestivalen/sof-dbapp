class Orchestra < ApplicationRecord
  CODE_SIZE_BYTES = 4

  belongs_to :user
  has_many :orchestra_signups, dependent: :destroy

  validates :name, presence: true

  before_save :ensure_access_code_present

  def generate_new_access_code
    self[:code] = SecureRandom.hex(n=CODE_SIZE_BYTES)
  end

  def has_member?(member)
    has_owner? member
  end

  def has_owner?(owner)
    user == owner
  end

  def members_count
    orchestra_signups.count()
  end

  private

  def ensure_access_code_present
    if code.nil?
      generate_new_access_code
    end
  end
end
