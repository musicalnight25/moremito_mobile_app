import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/flyer_interaction_model.dart';
import '../model/flyer_tracking_stats_model.dart';
import '../model/link_activity_details_model.dart';
import '../model/search_users_for_share_model.dart';
import '../model/shared_flyers_model.dart';
import '../model/shared_reports_users_model.dart';
import '../model/shared_reports_with_me_model.dart';
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

  // ---------------- SHARED REPORTS USERS ----------------
  RxBool sharedReportsUsersLoading = false.obs;
  RxList<SharedReportUser> sharedReportsUsers = <SharedReportUser>[].obs;

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
    int? userId,
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
        if (userId != null) "userId": userId,
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
  // FETCH SHARED REPORTS USERS
  // ============================================================
  Future<void> getSharedReportsUsers() async {
    sharedReportsUsersLoading.value = true;
    try {
      final response = await _repo.getUsersIHaveSharedReportsWith();
      if (response != null) {
        final model = sharedReportsUsersResponseFromJson(json.encode(response));
        if (model.status == true) {
          sharedReportsUsers.value = model.data ?? [];
        }
      }
    } catch (e) {
      debugPrint("Shared reports users error: $e");
    } finally {
      sharedReportsUsersLoading.value = false;
    }
  }

  // ============================================================
  // DELETE REPORT SHARE (used in SharedReportsUsersScreen)
  // ============================================================
  Future<bool> deleteReportShare(int shareId) async {
    try {
      final response = await _repo.deleteReportShare(shareId);
      if (response != null) {
        // Remove from list
        sharedReportsUsers.removeWhere((u) => u.shareId == shareId);
        return true;
      }
    } catch (e) {
      debugPrint("Delete report share error: $e");
    }
    return false;
  }

  // ============================================================
  // SHARED REPORTS WITH ME
  // ============================================================
  RxBool sharedReportsWithMeLoading = false.obs;
  RxList<SharedReportWithMeItem> sharedReportsWithMe =
      <SharedReportWithMeItem>[].obs;
  RxBool hasMoreSharedWithMe = false.obs;
  int _sharedWithMePage = 1;

  // ============================================================
  // SHARED USER STATS (for "View" — another user's tracking page)
  // ============================================================
  RxBool sharedUserStatsLoading = false.obs;
  Rxn<FlyerTrackingStats> sharedUserStats = Rxn<FlyerTrackingStats>();

  Future<void> getSharedLinksForUser(int userId) async {
    sharedUserStatsLoading.value = true;
    sharedUserStats.value = null;
    try {
      // Use my-shared-links?userId=X — as per the new requirement
      final response = await _repo.getSharedUserLinksStats(userId);
      if (response != null) {
        // The endpoint 'my-shared-links' wraps the stats inside 'TrackingInfo' under 'Data'
        // So we manually extract it to reuse the FlyerTrackingStats model
        if (response['Status'] == true) {
          final data = response['Data'];
          if (data != null) {
            final trackingInfo = data['TrackingInfo'];
            if (trackingInfo != null) {
              sharedUserStats.value = FlyerTrackingStats.fromJson(
                  Map<String, dynamic>.from(trackingInfo));
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Shared user stats error: $e');
    } finally {
      sharedUserStatsLoading.value = false;
    }
  }

  void resetSharedReportsWithMe() {
    _sharedWithMePage = 1;
    sharedReportsWithMe.clear();
    hasMoreSharedWithMe.value = false;
  }

  Future<void> getSharedReportsWithMe({bool loadMore = false}) async {
    if (!loadMore) {
      resetSharedReportsWithMe();
      sharedReportsWithMeLoading.value = true;
    }
    try {
      final response = await _repo.getSharedReportsWithMe(
          pageNumber: _sharedWithMePage, pageSize: 10);
      if (response != null) {
        final model =
            sharedReportsWithMeResponseFromJson(json.encode(response));
        if (model.status == true) {
          sharedReportsWithMe.addAll(model.data?.items ?? []);
          hasMoreSharedWithMe.value = model.data?.hasMore ?? false;
          if (hasMoreSharedWithMe.value) _sharedWithMePage++;
        }
      }
    } catch (e) {
      debugPrint("Shared reports with me error: $e");
    } finally {
      sharedReportsWithMeLoading.value = false;
    }
  }

  Future<bool> declineReportShare(int shareId, String comment) async {
    try {
      final response = await _repo.declineReportShare(shareId, comment);
      if (response != null) {
        sharedReportsWithMe.removeWhere((i) => i.id == shareId);
        return true;
      }
    } catch (e) {
      debugPrint("Decline report share error: $e");
    }
    return false;
  }

  // ============================================================
  // SHARE YOUR ACTIVITY — search users + save share
  // ============================================================
  RxBool searchUsersLoading = false.obs;
  RxList<ShareUserItem> searchUserResults = <ShareUserItem>[].obs;

  Future<void> searchUsersForShare(String username) async {
    if (username.trim().isEmpty) {
      searchUserResults.clear();
      return;
    }
    searchUsersLoading.value = true;
    try {
      final response = await _repo.searchUsersForShare(username.trim());
      if (response != null) {
        final model = searchUsersForShareFromJson(json.encode(response));
        if (model.status == true) {
          searchUserResults.assignAll(model.data ?? []);
        } else {
          searchUserResults.clear();
        }
      }
    } catch (e) {
      debugPrint('Search users error: $e');
      searchUserResults.clear();
    } finally {
      searchUsersLoading.value = false;
    }
  }

  Future<bool> saveReportShare({required int userId, String? note}) async {
    try {
      final response = await _repo.saveReportShare(userId: userId, note: note);
      return response != null;
    } catch (e) {
      debugPrint('Save report share error: $e');
      return false;
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
