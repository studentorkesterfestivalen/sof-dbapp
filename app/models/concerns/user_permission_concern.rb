module UserPermissionConcern
  def includes_permission?(permissions, permission)
    (permissions & permission) == permission
  end

  def includes_group_permission?(groups, group)
    if group == 0
      true
    else
      (groups & group) != 0
    end
  end
end