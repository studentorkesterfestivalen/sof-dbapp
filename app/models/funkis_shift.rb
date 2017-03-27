class FunkisShift < ApplicationRecord
  belongs_to :funkis_category, optional: true
  has_many :funkis_shift_applications

  def available?
    limit = ActiveFunkisShiftLimit.current

    if limit == 'red'
      funkis_shift_applications.count < red_limit
    elsif limit == 'yellow'
      funkis_shift_applications.count < yellow_limit
    else
      funkis_shift_applications.count < green_limit
    end
  end

  # Used by the controller to return the value without a questionmark in the key
  def available
    available?
  end
end
