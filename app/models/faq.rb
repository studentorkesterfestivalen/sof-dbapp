class Faq < ApplicationRecord
  belongs_to :faq_group, required: true
end
