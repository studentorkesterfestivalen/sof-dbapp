class FunkisShiftApplication < ApplicationRecord
  belongs_to :funkis_shift
  belongs_to :funkis_application, optional: true

  validate :does_not_exceed_limit

  def does_not_exceed_limit
    unless funkis_shift.available?
      errors[:base] << 'Application will exceed limit'
    end
  end
end
