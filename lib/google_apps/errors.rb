class GoogleAppsError < RuntimeError
  class AuthorizationFailed < GoogleAppsError; end
  class NotFound < GoogleAppsError; end
end