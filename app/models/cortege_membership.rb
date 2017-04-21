class CortegeMembership < ApplicationRecord
  belongs_to :user
  belongs_to :case_cortege
  belongs_to :cortege


  def add_cortege_membership(user, cortege)
    if cortege.has_member?(user)
      raise 'User is already a member of this cortege'
    else
      CortegeMembership.create(
          user_id: user.id,
          cortege_id: cortege.id
      )

      user.usergroup |= UserGroupPermissions::CORTEGE_MEMBER
      user.save
    end
  end

  def remove_cortege_membership(user, cortege)
    if cortege.has_member?
      CortegeMembership.where(user_id: user.id).destroy_all
      user.usergroup &= ~ UserGroupPermissions::CORTEGE_MEMBER
    else
      raise 'User not a member of this cortege'
    end
  end

  def add_case_cortege_membership(user, case_cortege)
    if case_cortege.has_member?(user)
      raise 'User is already a member of this cortege'
    else
      CortegeMembership.create(
          user_id: user.id,
          case_cortege_id: case_cortege.id
      )

      user.usergroup |= UserGroupPermissions::CORTEGE_MEMBER
      user.save
    end
  end

  def remove_case_cortege_membership(user, case_cortege)
    if case_cortege.has_member?
      CortegeMembership.where(user_id: user.id).destroy_all
      user.usergroup &= ~ UserGroupPermissions::CORTEGE_MEMBER
    else
      raise 'User not a member of this cortege'
    end
  end
end


