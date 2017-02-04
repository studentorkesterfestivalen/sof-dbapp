module UserPermissionConcern
  def includes_permission?(permissions, permission)
    (permissions & permission) == permission
  end
end