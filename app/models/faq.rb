class Faq < ApplicationRecord
  belongs_to :faq_group, required: true

  validate :all_fields_present, before: :create

  private

  def all_fields_present
    unless self.answer.present? && self.question.present? && self.faq_group_id.present?
      errors.add(:params, 'is missing')
    end
  end
end
