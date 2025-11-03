class ApiPaths {
  const ApiPaths._();

  /// login
  static const login = '/auth/login';
  static const loginResend = '/auth/login/resend';
  static const loginVerify = '/auth/login/verify';

  ///Register
  static const register = '/auth/register';
  static const registerResend = '/auth/register/resend';
  static const registerVerify = '/auth/register/verify';

  ///Forget Password
  static const forgetPassword = '/auth/reset/request';
  static const forgetPassOtpVerify = '/auth/reset/verify';
  static const forgetPassConfirm = '/auth/reset/confirm';

  /// Profile
  static const profile = '/auth/me';
  static const updateProfile = '/auth/update-profile';
  static const updatePassword = '/auth/change-password';
  static const requestPhoneOtp = '/auth/add-phone/request';
  static const verifyPhoneOtp = '/auth/add-phone/verify';
  static const identityVerify = '/auth/identity-verify';
  static const logOut = '/auth/logout';

  /// Plans
  static const allPlans = '/accounts/plans?get_all=true';

  ///Transactions
  static const transaction = '/accounts/transactions';

  /// Accounts
  static const myAccounts = '/accounts';

  /// Funding Sources
  static const fundingSources = '/accounts/funding-sources';

  //Reports
  static const dashboardAccounts = '/reports/saving-plans';
  static const dashboardRecentTransactions = '/reports/transactions';
  static const balanceReport = '/reports/balances';
  static const graphReport = '/reports/statements';

  // Notifications
  static const notifications = '/notifications';
  static const notificationOverview = '/notifications/overview';

  // Pages
  static const page = '/frontend/pages/';
}
