module UserPermissionConcern
  def includes_permission?(permissions, permission)
    permissions & (1 << permission) > 0
  end

  module Permission
    ALL = 0
    LIST_ORCHESTRA_SIGNUPS = 1
    MODIFY_ARTICLES = 2
  end
end