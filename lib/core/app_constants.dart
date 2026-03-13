class AppConstants {
  static const String appName = 'Bhishi Manager';
  
  // SharedPreferences Keys
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyUsername = 'username';
  static const String keyGroups = 'groups';
  static const String keyAgentProfile = 'agent_profile';
  
  // Default Credentials
  static const String defaultUsername = 'admin';
  static const String defaultPassword = 'admin@123';
  
  // Business Rules
  static const int maxMembersPerGroup = 10;
  static const double winnerInterestRate = 0.01; // 1%
  static const double agentCommissionRate = 0.02; // 2%
}
