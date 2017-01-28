module ViewPermissionConcern
  def require_permission(permission)
    if current_user.nil? or not current_user.has_permission?(permission)
      raise 'Missing permission for view'
    end
  end

  def require_membership(model)
    if current_user.nil? or not model.has_member?(current_user)
      raise 'Missing membership for model'
    end
  end

  def require_ownership(model)
    if current_user.nil? or not model.has_owner?(current_user)
      raise 'Is not owner of model'
    end
  end
end