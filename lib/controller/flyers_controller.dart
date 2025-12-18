import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/flyer_interaction_model.dart';
import '../model/flyer_tracking_stats_model.dart';
import '../model/shared_flyers_model.dart';
import '../service/network_repository.dart';
import '../utils/common_method.dart';

class FlyersController extends GetxController {
  final NetworkRepository _repo = NetworkRepository();

  // -------- STATS --------
  RxBool statsLoading = false.obs;
  Rxn<FlyerTrackingStats> stats = Rxn();

  // -------- SHARED FLYERS --------
  RxBool listLoading = false.obs;
  RxBool loadMoreLoading = false.obs;
  RxList<SharedFlyerItem> sharedFlyers = <SharedFlyerItem>[].obs;

  int page = 1;
  bool hasMore = true;

// -------- ACTIVITY --------
  RxBool activityLoading = false.obs;
  RxList<FlyerInteractionModel> interactions = <FlyerInteractionModel>[].obs;

  // ---------------- GET STATS ----------------
  Future<void> getFlyerTrackingStats() async {
    statsLoading.value = true;
    try {
      final response = await _repo.getFlyerTrackingStats();
      if (response != null) {
        final model = flyerTrackingStatsFromJson(json.encode(response));
        if (model.status == true) {
          stats.value = model.data;
        }
      }
    } catch (e) {
      debugPrint("Stats error: $e");
    } finally {
      statsLoading.value = false;
    }
  }

  // ---------------- GET SHARED FLYERS ----------------
  Future<void> getSharedFlyers({required String filterKey}) async {
    if (!hasMore && page != 1) return;

    page == 1 ? listLoading.value = true : loadMoreLoading.value = true;

    try {
      final response = await _repo.getSharedFlyers({
        "pageNumber": page,
        "pageSize": 10,
        "filterDays": filterKey,
      });

      if (response != null) {
        final model = sharedFlyersResponseFromJson(json.encode(response));

        if (model.status == true && model.data != null) {
          if (page == 1) sharedFlyers.clear();

          sharedFlyers.addAll(model.data!.items ?? []);

          hasMore = page < (model.data!.totalPages ?? 1);
          if (hasMore) page++;
        }
      }
    } catch (e) {
      debugPrint("Shared flyers error: $e");
    } finally {
      listLoading.value = false;
      loadMoreLoading.value = false;
    }
  }

  // ---------------- GET FLYER ACTIVITY ----------------
  Future<void> getFlyerInteractions({required int sharedFlyerId}) async {
    activityLoading.value = true;
    interactions.clear();

    try {
      final response =
          await _repo.getFlyerInteractions({'sharedLinkId': sharedFlyerId});
      if (response != null) {
        final model =
            flyerInteractionResponseModelFromJson(json.encode(response));
        if (model.status == true) {
          interactions.value = model.data ?? [];
        }
      }
    } catch (e) {
      debugPrint("Flyer activity error: $e");
    } finally {
      activityLoading.value = false;
    }
  }

  void resetPagination() {
    page = 1;
    hasMore = true;
    sharedFlyers.clear();
  }
}
