class CortegeMembership < ApplicationRecord
  belongs_to :user
  belongs_to :case_cortege, required: false
  belongs_to :cortege, required: false

  validates :user_id, presence: true
end


