module AdminPermission
  ALL                          = 1 << 0
  LIST_ORCHESTRA_SIGNUPS       = 1 << 1
  MODIFY_ARTICLES              = 1 << 2
  LIST_USERS                   = 1 << 3
  MODIFY_USERS                 = 1 << 4
  DELETE_USERS                 = 1 << 5
  LIST_CORTEGE_APPLICATIONS    = 1 << 6
  APPROVE_CORTEGE_APPLICATIONS = 1 << 7
  LIST_FUNKIS_APPLICATIONS     = 1 << 8
  ANALYST                      = 1 << 9
  TICKETER                     = 1 << 10
  EDITOR                       = 1 << 11
end
