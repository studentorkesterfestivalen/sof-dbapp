class FunkisShift < ApplicationRecord
  belongs_to :funkis_category, optional: true
  has_many :funkis_shift_applications

  def available?
    limit = ActiveFunkisShiftLimit.take[:active_limit]

    if limit == 0
      funkis_shift_applications.count < red_limit
    elsif limit == 1
      funkis_shift_applications.count < yellow_limit
    else
      funkis_shift_applications.count < green_limit
    end
  end
end
