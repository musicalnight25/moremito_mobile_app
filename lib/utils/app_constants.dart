class AppConstants {
  //live
  static String apiEndPoint = "http://mormito.com/api/mobile/";
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
  static const String logout = 'logout';
  static const String getNotificationDetail =
      'get-notification-detail?NotificationId=';
  static const String mobileSaveFileShare = 'save-file-share';
  static const String generateLink = 'generate-link';
}
