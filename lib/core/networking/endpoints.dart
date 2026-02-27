class ApiEndpoints {
  // Auth endpoints
  static const authLogin = '/api/auth/login';
  static const authRegister = '/api/auth/register';
  static const authChangePassword = '/api/auth/change-password';
  static const users = '/api/users';
  
  // Customer endpoints
  static const customers = '/api/customers';
  static String customerById(int id) => '/api/customers/$id';
  static String customerByNic(String nic) => '/api/customers/nic/$nic';
  
  // Route endpoints
  static const routes = '/api/routes';
  static String routeByCode(String code) => '/api/routes/$code';
  
  // Loan Package endpoints
  static const loanPackages = '/api/loan-packages';
  static String loanPackageByCode(String code) => '/api/loan-packages/$code';
  
  // Loan endpoints
  static const loans = '/api/loans';
  static String loanByNumber(String number) => '/api/loans/$number';
  static String loanState(int id) => '/api/loans/$id/state';
  static const loanClose = '/api/loans/close';
  
  // Payment endpoints
  static const paymentCollect = '/api/payments/collect';
  static String paymentsByLoan(String loanNumber) => '/api/payments/loan/$loanNumber';
  static String paymentsByCustomer(String nic) => '/api/payments/customer/$nic';
  static String routeCollections(String routeCode) => '/api/payments/route/$routeCode/collections';
}
