module UserPermissionConcern
  def includes_permission?(permissions, permission)
    permissions & permission > 0
  end
end