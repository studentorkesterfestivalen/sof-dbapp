class FunkisCategory < ApplicationRecord
  has_many :funkis_shifts
  accepts_nested_attributes_for :funkis_shifts

  def available_shifts
    funkis_shifts.select { |p| p.available? }
  end
end
