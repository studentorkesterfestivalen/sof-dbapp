class FaqGroup < ApplicationRecord
  has_many :faqs, dependent: :destroy
end

