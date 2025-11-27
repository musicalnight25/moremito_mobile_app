class AppConstants {
  //live
  // static String apiEndPoint = "http://mormito.com/api/mobile/"; DEV
  static String apiEndPoint = "https://moremito.com/api/mobile/"; //LIVE

  static String netWorkFileUrl = "${AppConstants.apiEndPoint}file/";

  static const String loginWithPassword = 'login';
  static const String registerDeviceToken = 'register-device-token';
  static const String getSurveyQuestions = 'get-survey-questions';
  static const String saveSurvey = 'save-survey';
  static const String getCategories = 'get-categories';
  static const String getSubCategories = 'get-sub-categories?Categoryid=';
  static const String getSubCategoriesFiles =
      'get-sub-categories-files?SubCategoryId=';
  static const String getNotification = 'get-notifications';
  static const String getDashboard = 'get-dashboard';
  static const String getOrders = 'get-order-list';
  static const String getOrderDetail = 'get-order-detail';
  static const String getCallDetails = 'get-call-details?';
  static const String getAnnouncementDetails =
      'get-announcement-details?AnnnoucementId=';
  static const String logout = 'logout';
  static const String getNotificationDetail =
      'get-notification-detail?NotificationId=';
  static const String mobileSaveFileShare = 'save-file-share';
  static const String generateLink = 'generate-link';
  static const String getSupportTickets = 'get-support-tickets';
  static const String getTicketPriorities = 'get-ticket-priorities';
  static const String getTicketModules = 'get-ticket-modules';
  static const String getTicketComments = 'get-ticket-comments';
  static const String createSupportTicket = 'create-support-ticket';
  static const String addTicketComment = 'add-ticket-comment';
}
