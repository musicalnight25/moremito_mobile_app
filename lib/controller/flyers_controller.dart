import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/flyer_interaction_model.dart';
import '../model/flyer_tracking_stats_model.dart';
import '../model/link_activity_details_model.dart';
import '../model/shared_flyers_model.dart';
import '../service/network_repository.dart';

class FlyersController extends GetxController {
  final NetworkRepository _repo = NetworkRepository();

  // ---------------- STATS ----------------
  RxBool statsLoading = false.obs;
  Rxn<FlyerTrackingStats> stats = Rxn<FlyerTrackingStats>();

  // ---------------- SHARED FLYERS ----------------
  RxBool listLoading = false.obs;
  RxBool loadMoreLoading = false.obs;

  RxList<SharedFlyerItem> sharedFlyers = <SharedFlyerItem>[].obs;

  int page = 1;
  bool hasMore = true;

  RxnString currentFileType = RxnString();

  // ---------------- ACTIVITY ----------------
  RxBool activityLoading = false.obs;

  // RxList<FlyerInteractionModel> interactions = <FlyerInteractionModel>[].obs;
  RxList<LinkActivityDetailsModel> linkActivityDetailsModel =
      <LinkActivityDetailsModel>[].obs;

  // ============================================================
  // FETCH STATS
  // ============================================================
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

  Future<void> getSharedFlyers({
    required String filterKey,
    String? search,
    String? fileType,
  }) async {
    if (!hasMore && page != 1) return;
    if (listLoading.value || loadMoreLoading.value) return;

    final isFirstPage = page == 1;
    isFirstPage ? listLoading.value = true : loadMoreLoading.value = true;

    currentFileType.value = fileType;

    try {
      final response = await _repo.getSharedFlyers({
        "pageNumber": page,
        "pageSize": 10,
        "filterDays": filterKey,
        "sharedTo": (search == null || search.isEmpty) ? null : search,
        "filterType": mapFileTypeToApi(fileType),
      });

      if (response == null) return;

      final model = sharedFlyersResponseFromJson(json.encode(response));

      if (model.status == true) {
        final items = model.data?.items ?? [];

        if (isFirstPage) {
          sharedFlyers.clear();
        }

        if (items.isNotEmpty) {
          sharedFlyers.addAll(items);
        }

        // ✅ RELY ON API HasMore
        hasMore = model.data?.hasMore ?? false;

        // ✅ increment page ONLY when more data exists
        if (hasMore) {
          page++;
        }
      }
    } catch (e) {
      debugPrint("Shared flyers error: $e");
    } finally {
      listLoading.value = false;
      loadMoreLoading.value = false;
    }
  }

  // ============================================================
  // RESET PAGINATION
  // ============================================================
  void resetPagination() {
    page = 1;
    hasMore = true;
    sharedFlyers.clear();
  }

  // ============================================================
  // FETCH ACTIVITY
  // ============================================================
  // Future<void> getFlyerInteractions({required int sharedFlyerId}) async {
  //   activityLoading.value = true;
  //   interactions.clear();
  //
  //   try {
  //     final response =
  //         await _repo.getFlyerInteractions({'sharedLinkId': sharedFlyerId});
  //
  //     if (response != null) {
  //       final model =
  //           flyerInteractionResponseModelFromJson(json.encode(response));
  //       if (model.status == true) {
  //         interactions.value = model.data ?? [];
  //       }
  //     }
  //   } catch (e) {
  //     debugPrint("Flyer activity error: $e");
  //   } finally {
  //     activityLoading.value = false;
  //   }
  // }
  Future<void> getLinkActivityDetails({
    required int fileShareId,
    required int fileType,
    required String sharedTo,
  }) async {
    activityLoading.value = true;
    linkActivityDetailsModel.clear();

    try {
      final response = await _repo.getLinkActivityDetails({
        'fileShareId': fileShareId,
        'fileType': fileType,
        'sharedTo': sharedTo
      });

      if (response != null) {
        final model =
            linkActivityDetailsResponseModelFromJson(json.encode(response));
        if (model.status == true) {
          linkActivityDetailsModel.value = model.data?.items ?? [];
        }
      }
    } catch (e) {
      debugPrint("Flyer activity error: $e");
    } finally {
      activityLoading.value = false;
    }
  }

  // ============================================================
  // HELPERS
  // ============================================================
  int? mapFileTypeToApi(String? value) {
    switch (value) {
      case "Files":
        return 1;
      case "Flyers":
        return 2;
      case "SMS":
        return 3;
      default:
        return null;
    }
  }
}
