import 'dart:convert';

RankInfoResponse rankInfoResponseFromJson(String str) =>
    RankInfoResponse.fromJson(json.decode(str));

class RankInfoResponse {
  bool? status;
  String? message;
  RankInfoData? data;

  RankInfoResponse({this.status, this.message, this.data});

  factory RankInfoResponse.fromJson(Map<String, dynamic> json) =>
      RankInfoResponse(
        status: json["Status"],
        message: json["Message"],
        data: json["Data"] != null ? RankInfoData.fromJson(json["Data"]) : null,
      );
}

class RankInfoData {
  String? currentRank;
  String? highestRankAchieved;
  List<RankHistory>? rankHistory;

  RankInfoData({this.currentRank, this.highestRankAchieved, this.rankHistory});

  factory RankInfoData.fromJson(Map<String, dynamic> json) => RankInfoData(
        currentRank: json["CurrentRank"],
        highestRankAchieved: json["HighestRankAchieved"],
        rankHistory: json["RankHistory"] == null
            ? []
            : List<RankHistory>.from(
                json["RankHistory"].map((x) => RankHistory.fromJson(x))),
      );
}

class RankHistory {
  String? date;
  String? orderNo;
  String? rank;
  String? userType;

  RankHistory({this.date, this.orderNo, this.rank, this.userType});

  factory RankHistory.fromJson(Map<String, dynamic> json) => RankHistory(
        date: json["Date"],
        orderNo: json["OrderNo"],
        rank: json["Rank"],
        userType: json["UserType"],
      );
}
