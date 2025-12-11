// lib/controller/flyers_controller.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/service/network_repository.dart';
import 'package:more_mitro_app/utils/common_method.dart';

import '../model/flyer_models.dart';

class FlyersController extends GetxController {
  final NetworkRepository _repo = NetworkRepository();

  // ------------------ TRACKING STATS (tiles) ------------------
  RxBool statsLoading = false.obs;
  Rxn<FlyerTrackingStats> stats = Rxn<FlyerTrackingStats>();

  // ------------------ SHARED FLYERS (paginated list) ------------------
  RxBool listLoading = false.obs;
  RxBool loadMoreLoading = false.obs;
  RxList<SharedFlyerItem> sharedFlyers = <SharedFlyerItem>[].obs;

  // pagination
  int page = 1;
  bool hasMore = true;

  // ------------------ INTERACTIONS (activity) ------------------
  RxBool activityLoading = false.obs;
  RxList<FlyerInteraction> interactions = <FlyerInteraction>[].obs;

  // -------------------------------------------------------------------
  // GET TRACKING STATS (tiles)
  // -------------------------------------------------------------------
  Future<void> getFlyerTrackingStats() async {
    statsLoading.value = true;
    try {
      var response = await _repo.getFlyerTrackingStats();
      debugPrint("RAW FLYER STATS RESPONSE: $response");
      if (response != null) {
        final model = flyerTrackingStatsFromJson(json.encode(response));
        if (model.status == true && model.data != null) {
          stats.value = model.data;
        } else {
          CommonMethod.getXSnackBar(
            "Error",
            model.message ?? "Unable to fetch stats",
            Colors.red,
          );
        }
      }
    } catch (e, s) {
      debugPrint("❌ Error in getFlyerTrackingStats: $e\n$s");
    } finally {
      statsLoading.value = false;
    }
  }

  // -------------------------------------------------------------------
  // GET SHARED FLYERS (paginated)
  // filterKey should be one of: last72hours, last7days, days8to14, days15to21, days22to28, lifetime
  // -------------------------------------------------------------------
  Future<void> getSharedFlyers({required String filterKey}) async {
    if (!hasMore && page != 1) return;

    if (page == 1) {
      listLoading.value = true;
    } else {
      loadMoreLoading.value = true;
    }

    try {
      Map<String, dynamic> queryParameters = {
        "pageNumber": page.toString(),
        "pageSize": 10.toString(),
        "filterDays": filterKey,
      };

      var response = await _repo.getSharedFlyers(queryParameters);
      debugPrint("RAW SHARED FLYERS RESPONSE: $response");

      if (response != null) {
        final model = sharedFlyersResponseFromJson(json.encode(response));
        if (model.status == true && model.data != null) {
          if (page == 1) sharedFlyers.clear();
          sharedFlyers.addAll(model.data!.items ?? []);
          hasMore = model.data!.hasMore ?? false;

          sharedFlyers.refresh();
          if (hasMore) page++;
        } else {
          CommonMethod.getXSnackBar("Error",
              model.message ?? "Unable to fetch shared flyers", Colors.red);
        }
      }
    } catch (e, s) {
      debugPrint("❌ Error in getSharedFlyers: $e\n$s");
    } finally {
      listLoading.value = false;
      loadMoreLoading.value = false;
    }
  }

  // -------------------------------------------------------------------
  // GET FLYER INTERACTIONS
  // -------------------------------------------------------------------
  Future<void> getFlyerInteractions({required int sharedLinkId}) async {
    activityLoading.value = true;
    try {
      var response = await _repo.getFlyerInteractions(sharedLinkId);
      debugPrint("RAW FLYER INTERACTIONS: $response");
      if (response != null) {
        final model = flyerInteractionsFromJson(json.encode(response));
        // if (model.status == true && model.data != null) {
        //   interactions.value = model.data ?? [];
        // } else {
        //   CommonMethod.getXSnackBar("Error",
        //       model.message ?? "Unable to fetch interactions", Colors.red);
        // }
      }
    } catch (e, s) {
      debugPrint("❌ Error in getFlyerInteractions: $e\n$s");
    } finally {
      activityLoading.value = false;
    }
  }

  // helper to reset pagination (call before a fresh fetch)
  void resetPagination() {
    page = 1;
    hasMore = true;
    sharedFlyers.clear();
  }
}
