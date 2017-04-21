class FunkisShift < ApplicationRecord
  belongs_to :funkis_category, optional: true
  has_many :funkis_shift_applications

  def available?
    limit = ActiveFunkisShiftLimit.current

    if limit == 'red'
      completed_applications_count < red_limit
    elsif limit == 'yellow'
      completed_applications_count < yellow_limit
    else
      completed_applications_count < green_limit
    end
  end

  # Used by the controller to return the value without a questionmark in the key
  def available
    available?
  end

  def completed_applications_count
    completed_applications = funkis_shift_applications.select {|x| x.funkis_application.completed?}
    completed_applications.count
  end
end
