class ApiConstants {
  static const String baseUrl = 'https://sydkic.com';
  static const String api = '$baseUrl/api';
  static const String login = '$api/login';
  static const String logout = '$api/logout';
  static const String getContactDatas = '$api/get_contact_datas';
  static const String getDashboardDetails = '$api/get_dashboard_details';
  static const String getAssistantList = '$api/get_assistant_list';
  static const String getAssistantContacts = '$api/get_assistant_contacts';
  static const String updateAssistantStatus = '$api/update_assistant_status';
  static const String getScheduledList = '$api/get_schedule_list';
  static const String getContactAssistent = '$api/get_contact_assistant';
  static const String createAssistentContact = '$api/create_assistant_contact';
  static const String getAssistentContact = '$api/get_assistant_contacts';
  static const String sendSms = '$api/send-sms';
  static const String receiveSms = '$api/receive-sms';
}
