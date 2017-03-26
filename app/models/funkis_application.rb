class FunkisApplication < ApplicationRecord
  has_many :funkis_shift_applications

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
end
