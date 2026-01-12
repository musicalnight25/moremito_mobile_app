import 'dart:convert';
import 'package:get/get.dart';
import '../model/rank_history_model.dart';
import '../service/network_repository.dart';
import '../service/error_logger.dart';

class RankInfoController extends GetxController {
  final NetworkRepository _repo = NetworkRepository();

  RxBool isLoading = false.obs;
  Rxn<RankInfoData> rankInfo = Rxn<RankInfoData>();

  @override
  void onInit() {
    super.onInit();
    fetchRankInfo();
  }

  Future<void> fetchRankInfo() async {
    try {
      isLoading.value = true;

      // final response = await _repo.getRankInfo();
      final response = {
        "Status": true,
        "Message": null,
        "Data": {
          "CurrentRank": "Ambassador",
          "HighestRankAchieved": "Silver",
          "RankHistory": [
            {
              "Date": "09/06/2025",
              "OrderNo": "",
              "Rank": "Ambassador",
              "UserType": ""
            },
            {
              "Date": "06/25/2025",
              "OrderNo": "82100",
              "Rank": "Silver",
              "UserType": ""
            },
            {
              "Date": "10/19/2024",
              "OrderNo": "",
              "Rank": "Ambassador",
              "UserType": ""
            },
            {
              "Date": "08/24/2024",
              "OrderNo": "",
              "Rank": "Sr. Ambassador",
              "UserType": ""
            },
            {
              "Date": "08/04/2024",
              "OrderNo": "50805",
              "Rank": "Silver",
              "UserType": ""
            },
            {
              "Date": "08/01/2024",
              "OrderNo": "50526",
              "Rank": "Sr. Ambassador",
              "UserType": ""
            },
            {
              "Date": "07/13/2024",
              "OrderNo": "",
              "Rank": "Ambassador",
              "UserType": ""
            },
            {
              "Date": "05/18/2024",
              "OrderNo": "",
              "Rank": "Sr. Ambassador",
              "UserType": ""
            },
            {
              "Date": "04/19/2024",
              "OrderNo": "41543",
              "Rank": "Sr. Ambassador",
              "UserType": ""
            },
            {
              "Date": "02/29/2024",
              "OrderNo": "38737",
              "Rank": "Sr. Ambassador",
              "UserType": ""
            },
            {
              "Date": "12/02/2023",
              "OrderNo": "",
              "Rank": "Ambassador",
              "UserType": ""
            },
            {
              "Date": "10/29/2023",
              "OrderNo": "33278",
              "Rank": "Sr. Ambassador",
              "UserType": ""
            },
            {
              "Date": "06/24/2023",
              "OrderNo": "",
              "Rank": "Ambassador",
              "UserType": ""
            },
            {
              "Date": "06/07/2023",
              "OrderNo": "27625",
              "Rank": "Sr. Ambassador",
              "UserType": ""
            },
            {
              "Date": "04/29/2023",
              "OrderNo": "",
              "Rank": "Ambassador",
              "UserType": ""
            },
            {
              "Date": "10/13/2022",
              "OrderNo": "22943",
              "Rank": "Silver",
              "UserType": ""
            },
            {
              "Date": "09/20/2022",
              "OrderNo": "22647",
              "Rank": "Ambassador",
              "UserType": ""
            }
          ]
        }
      };
      if (response != null) {
        final model = rankInfoResponseFromJson(json.encode(response));

        if (model.status == true && model.data != null) {
          rankInfo.value = model.data;
        }
      }
    } catch (e, stack) {
      await ErrorLogger.logErrorToServer(
        pageType: "RankInfo",
        actionType: "Fetch",
        errorMessage1: e.toString(),
        errorMessage2: "fetchRankInfo failed",
        errorMessage3: stack.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
