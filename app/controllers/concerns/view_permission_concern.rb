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

  def require_membership_or_permission(model, permissions)
    if current_user.nil?
      raise 'Not logged in'
    end

    unless model.has_member?(current_user) or current_user.has_permission?(permissions)
      raise 'Is not member of model or lacks required permissions'
    end
  end

  def require_ownership_or_permission(model, permissions)
    if current_user.nil?
      raise 'Not logged in'
    end

    unless model.has_owner?(current_user) or current_user.has_permission?(permissions)
      raise 'Is not owner of model or lacks required permissions'
    end
  end

  def disable_feature(from: nil)
    # Disabled features should not affect automated tests
    return if Rails.env.test?

    # Allow setting a date for when the feature should be automatically disabled
    return if from and Date.parse(from) > Date.today

    # Always allow administrators to access the feature
    if current_user.nil? or not current_user.has_permission?(Permission::ALL)
      raise 'Feature disabled'
    end
  end
end