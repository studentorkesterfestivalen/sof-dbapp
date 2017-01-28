class Orchestra < ApplicationRecord
  CODE_SIZE_BYTES = 4

  belongs_to :user
  has_many :orchestra_signups

  before_save :ensure_access_code_present

  def ensure_access_code_present
    if code.nil?
      self[:code] = SecureRandom.hex(n=CODE_SIZE_BYTES)
    end
  end

  def has_member?(member)
    has_owner? member
  end

  def has_owner?(owner)
    user == owner
  end
end
