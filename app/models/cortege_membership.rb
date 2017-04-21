class CortegeMembership < ApplicationRecord
  belongs_to :user
  belongs_to :case_cortege
  belongs_to :cortege
end
