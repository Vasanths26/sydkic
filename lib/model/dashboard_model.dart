
class DashboardDetails {
  String? status;
  int? totalDevice;
  int? activeDevice;
  // int? tokens;
  List<String>? weeklyLabels;
  List<int>? weeklyMessages;
  List<int>? weeklyTokens;
  int? totalMessages;
  int? totalConversations;
  int? totalAssistants;
  int? activeAssistants;
  int? totalCampaigns;
  int? activeCampaigns;

  DashboardDetails(
      {this.status,
        this.totalDevice,
        this.activeDevice,
        // this.tokens,
        this.weeklyLabels,
        this.weeklyMessages,
        this.weeklyTokens,
        this.totalMessages,
        this.totalConversations,
        this.totalAssistants,
        this.activeAssistants,
        this.totalCampaigns,
        this.activeCampaigns});

  DashboardDetails.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalDevice = json['total_device'];
    activeDevice = json['active_device'];
    // tokens = json['tokens'];
    weeklyLabels = json['weeklyLabels'].cast<String>();
    weeklyMessages = json['weeklyMessages'].cast<int>();
    weeklyTokens = json['weeklyTokens'].cast<int>();
    totalMessages = json['total_messages'];
    totalConversations = json['total_conversations'];
    totalAssistants = json['total_assistants'];
    activeAssistants = json['active_assistants'];
    totalCampaigns = json['total_campaigns'];
    activeCampaigns = json['active_campaigns'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['total_device'] = totalDevice;
    data['active_device'] = activeDevice;
    // data['tokens'] = this.tokens;
    data['weeklyLabels'] = weeklyLabels;
    data['weeklyMessages'] = weeklyMessages;
    data['weeklyTokens'] = weeklyTokens;
    data['total_messages'] = totalMessages;
    data['total_conversations'] = totalConversations;
    data['total_assistants'] = totalAssistants;
    data['active_assistants'] = activeAssistants;
    data['total_campaigns'] = totalCampaigns;
    data['active_campaigns'] = activeCampaigns;
    return data;
  }
}