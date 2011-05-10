# define any custom errors that our app should throw

module WatchMeMakeThis
  
  # thrown if you try to reference the current_user but no user is logged in
  class UserNotLoggedIn < StandardError; end;
  
end