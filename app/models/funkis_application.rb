class FunkisApplication < ApplicationRecord
  belongs_to :user, optional: true
  has_many :funkis_shift_applications

  accepts_nested_attributes_for :funkis_shift_applications

  validate :has_valid_presale_option?, :is_not_locked?

  PRESALE_NONE = 0
  PRESALE_MH = 1
  PRESALE_UK = 2

  def has_owner?(owner)
    user == owner
  end

  def ready_for_step?(step)
    case step
      when 1
        true
      when 2
        information_filled_in?
      when 3
        shifts_selected?
      when 4
        terms_agreed?
      else
        false
    end
  end

  private

  def information_filled_in?
    required_fields = [:ssn, :phone, :tshirt_size, :allergies, :presale_choice]
    not required_fields.any? { |f| send(f).nil? }
  end

  def shifts_selected?
    funkis_shift_applications.any?
  end

  def terms_agreed?
    not terms_agreed_at.nil?
  end

  def has_valid_presale_option?
    unless presale_choice == PRESALE_NONE or
           presale_choice == PRESALE_MH or
           presale_choice == PRESALE_UK
      errors[:base] << 'Ogiltigt val av förköp'
    end
  end

  def is_not_locked?
    unless terms_agreed_at_was.nil?
      errors[:base] << 'Anmälan redan gjord'
    end
  end
end
