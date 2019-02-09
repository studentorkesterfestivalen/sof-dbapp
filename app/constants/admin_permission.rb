module AdminPermission
  ALL                          = 1 << 0
  ORCHESTRA_ADMIN              = 1 << 1 # For creating unlimited orchestras and listing all
  LIST_ORCHESTRA_SIGNUPS       = 1 << 2
  MODIFY_ARTICLES              = 1 << 3
  LIST_USERS                   = 1 << 4
  MODIFY_USERS                 = 1 << 5
  DELETE_USERS                 = 1 << 6
  LIST_CORTEGE_APPLICATIONS    = 1 << 7
  APPROVE_CORTEGE_APPLICATIONS = 1 << 8
  LIST_FUNKIS_APPLICATIONS     = 1 << 9
  ANALYST                      = 1 << 10
  TICKETER                     = 1 << 11
  EDITOR                       = 1 << 12
end
