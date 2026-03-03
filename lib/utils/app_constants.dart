class AppConstants {
  //live
  static String apiEndPoint = "http://mormito.com/api/mobile/"; //DEV
  // static String apiEndPoint = "https://moremito.com/api/mobile/"; //LIVE

  static String netWorkFileUrl = "${AppConstants.apiEndPoint}file/";

  static const String loginWithPassword = 'login';
  static const String registerDeviceToken = 'register-device-token';
  static const String getSurveyQuestions = 'get-survey-questions';
  static const String getSurveyResponses = 'get-survey-responses';
  static const String saveSurvey = 'save-survey';
  static const String getCategories = 'get-categories';
  static const String getSubCategories = 'get-sub-categories?Categoryid=';
  static const String getSubCategoriesFiles = 'get-sub-categories-files';
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
  static const String generateFlyerShareLink = 'generate-flyer-share-link';
  static const String getSupportTickets = 'get-support-tickets';
  static const String getTicketPriorities = 'get-ticket-priorities';
  static const String getTicketModules = 'get-ticket-modules';
  static const String getTmrisContent = 'tmris-content';
  static const String getPushNotificationSettings =
      'get-push-notification-settings';
  static const String savePushNotificationSetting =
      'save-push-notification-setting';
  static const String savePushNotificationSettingsBulk =
      'save-push-notification-settings-bulk';
  static const String getTicketComments = 'get-ticket-comments';
  static const String createSupportTicket = 'create-support-ticket';
  static const String addTicketComment = 'add-ticket-comment';
  static const String getFlyerTrackingStats = 'get-flyer-tracking-stats';
  static const String getSharedFlyers = 'get-shared-flyers';
  static const String getFlyerInteractions = 'get-flyer-interactions';
  static const String getLinkActivityDetails = 'get-link-activity-details';
  static const String archiveLead = 'archive-lead';
  static const String getMyLeads = 'my-leads';
  static const String getTmrisLeads = 'get-tmris-leads';
  static const String archiveTmrisLead = 'archive-tmris-lead';
  static const String getMyProfile = 'my-info';
  static const String getFlyerTemplates = 'get-flyer-templates';
  static const String getFlyerTemplateDetail = 'get-flyer-template-detail';
  static const String getFlyerPreview = 'get-flyer-data';
  static const String updateMyProfile = 'update-my-info';
  static const String getMyAddresses = 'my-addresses';
  static const String saveAddress = 'save-address';
  static const String updateWelcomeTag = 'update-welcome-tag';
  static const String getWelcomeTag = 'welcome-tag';
  static const String getUserRoleInfo = 'user-role-info';
  static const String changePassword = 'change-password';
  static const String changeUserRole = 'change-user-role';
  static const String saveFlyerDetails = 'save-flyer';
  static const String markAllNotificationsRead =
      'mark-all-notifications-as-read';
  static const String saveLeadNotes = 'save-lead-notes';
  static const String markLeadAsContacted = 'mark-lead-as-contacted';
  static const String getWebviewToken = 'webview-token';
  static const String deepLinks = 'deep-links';
  static const String getRankInfo = 'rank-info';
  static const String myCompensationHistory = 'my-compensation-history';
  static const String myCompensationHistoryYear =
      'my-compensation-history/year';
  static const String myCompensationsGrouped = 'my-compensations-grouped';
  static const String myCompensationsByOrder = 'my-compensations/order';
  static const String myCompensations = 'my-compensations';
  static const String myCommissionRequestHistory =
      'my-commission-request-history';

  static const String myCashTransferHistory = 'my-cash-transfer-history';

  static const String myCommissionSpent = 'my-commission-spent';
  static const String myCashSentHistory = 'my-cash-sent-history';
  static const String getCountries = 'get-countries';
  static const String getStates = 'get-states';
  static const String myReferralOrders = 'get-orders-from-personals';
  static const String myReferralOrderDetail = 'get-orders-detail';
  static const String downlineOrders = 'downline-orders';
  static const String downlineOrderDetails = 'downline-order-details';
  static const String getUsersIHaveSharedReportsWith =
      'get-users-i-have-shared-reports-with';
  static const String getSharedReportsWithMe = 'get-shared-reports-with-me';
  static const String deleteReportShare = 'delete-report-share';
  static const String declineReportShare = 'decline-report-share';
  static const String mySharedLinks = 'my-shared-links';
}
