class ActiveFunkisShiftLimit < ApplicationRecord
  before_create :there_can_be_only_one #highlander

  def self.current
    limit_code = ActiveFunkisShiftLimit.take[:active_limit]
    if limit_code == 0
      'red'
    elsif limit_code == 1
      'yellow'
    else
      'green'
    end
  end

  def self.raise_limit
    # Dont raise above green limit
    if ActiveFunkisShiftLimit.first(:active_limit) < 2
      ActiveFunkisShiftLimit.first.increment(:active_limit)
    end
  end

  private

  def there_can_be_only_one
    raise 'There can only be one limit!' if ActiveFunkisShiftLimit.count > 0
  end
end
