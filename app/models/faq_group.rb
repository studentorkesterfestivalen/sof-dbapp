class FaqGroup < ApplicationRecord
  has_many :faqs, dependent: :destroy

  def number_of_faqs
    self.faqs.count
  end
end

