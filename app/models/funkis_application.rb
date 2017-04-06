class FunkisApplication < ApplicationRecord
  belongs_to :user, optional: true
  has_many :funkis_shift_applications, dependent: :destroy

  accepts_nested_attributes_for :funkis_shift_applications, allow_destroy: true

  validate :has_valid_presale_option?, :is_not_locked?, :completed_with_available_shifts?
  validates :ssn, presence: true
  validates :phone, presence: true
  validates :tshirt_size, presence: true

  PRESALE_NONE = 0
  PRESALE_MH = 1

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

  def steps_completed
    (0..2).each do |step|
      return step unless ready_for_step?(step + 2)
    end

    return 3
  end

  def completed?
    terms_agreed?
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
    unless presale_choice == PRESALE_NONE || presale_choice == PRESALE_MH
      errors[:base] << 'Ogiltigt val av förköp'
    end
  end

  def is_not_locked?
    unless terms_agreed_at_was.nil?
      errors[:base] << 'Anmälan redan gjord'
    end
  end

  def completed_with_available_shifts?
    if terms_agreed? and funkis_shift_applications.any? {|x| not x.funkis_shift.available?}
      errors[:base] << 'Ett eller fler pass är fulla'
    end
  end
end
