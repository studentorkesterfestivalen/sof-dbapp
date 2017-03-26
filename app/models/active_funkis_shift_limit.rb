class ActiveFunkisShiftLimit < ApplicationRecord
  before_create :there_can_be_only_one #highlander

  def current
    limit_code = ActiveFunkisShiftLimit.take
    if limit_code == 0
      'red'
    elsif limit_code == 1
      'yellow'
    else
      'green'
    end
  end

  private

  def there_can_be_only_one
    raise 'There can only be one limit!' if ActiveFunkisShiftLimit.count > 0
  end
end
