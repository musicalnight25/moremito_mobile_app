import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/lead_model.dart';
import '../service/network_repository.dart';
import '../service/error_logger.dart';

class MyLeadController extends GetxController {
  final NetworkRepository _networkRepository = NetworkRepository();

  RxList<LeadModel> leadList = <LeadModel>[].obs;

  RxBool isLoading = false.obs;
  RxBool isPaginationLoading = false.obs;
  RxBool hasMoreData = true.obs;

  RxBool isArchivedTab = false.obs;

  int pageNumber = 1;
  final int pageSize = 5;

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    _setupScroll();
  }

  void _setupScroll() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 120 &&
          !isPaginationLoading.value &&
          hasMoreData.value) {
        loadMoreLeads();
      }
    });
  }

  /// INITIAL LOAD
  Future<void> initialLoad() async {
    isLoading.value = true;
    await refreshLeads();
    isLoading.value = false;
  }

  /// TAB SWITCH
  Future<void> changeArchiveTab(bool archived) async {
    isArchivedTab.value = archived;
    await refreshLeads();
  }

  /// REFRESH
  Future<void> refreshLeads() async {
    pageNumber = 1;
    hasMoreData.value = true;

    final list = await _fetchLeads();
    if (list != null) {
      leadList.assignAll(list);
    }
  }

  /// PAGINATION
  Future<void> loadMoreLeads() async {
    isPaginationLoading.value = true;
    pageNumber++;

    final list = await _fetchLeads();
    if (list != null) {
      leadList.addAll(list);
    }

    isPaginationLoading.value = false;
  }

  /// API FETCH
  Future<List<LeadModel>?> _fetchLeads() async {
    try {
      final response = await _networkRepository.getMyLeads(
        queryParameters: {
          "pageNumber": pageNumber,
          "pageSize": pageSize,
          "isArchived": isArchivedTab.value,
        },
      );

      if (response != null) {
        final model = myLeadResponseFromJson(json.encode(response));

        if (model.status == true && model.data != null) {
          hasMoreData.value = pageNumber < (model.data!.totalPages ?? 1);
          return model.data!.leads ?? [];
        }
      }
    } catch (e, stack) {
      await ErrorLogger.logErrorToServer(
        pageType: "MyLeads",
        actionType: "Fetch",
        errorMessage1: e.toString(),
        errorMessage3: stack.toString(),
      );
    }

    return null;
  }

  /// ARCHIVE / UNARCHIVE
  Future<void> toggleArchive(int leadId, bool archive) async {
    try {
      final response = await _networkRepository.archiveLead(
        data: {
          "LeadId": leadId,
          "IsArchived": archive,
        },
      );

      if (response != null && response["Status"] == true) {
        leadList.removeWhere((e) => e.id == leadId);
      }
    } catch (e, stack) {
      await ErrorLogger.logErrorToServer(
        pageType: "MyLeads",
        actionType: "Archive",
        errorMessage1: e.toString(),
        errorMessage3: stack.toString(),
      );
    }
  }

  /// SAVE INTERNAL NOTES
  Future<bool> saveInternalNotes({
    required int leadId,
    required String notes,
  }) async {
    try {
      final response = await _networkRepository.saveLeadNotes(
        data: {
          "LeadId": leadId,
          "InternalNotes": notes,
        },
      );

      if (response != null && response["Status"] == true) {
        return true;
      }
    } catch (e, stack) {
      await ErrorLogger.logErrorToServer(
        pageType: "LeadDetails",
        actionType: "SaveNotes",
        errorMessage1: e.toString(),
        errorMessage3: stack.toString(),
      );
    }
    return false;
  }

  /// MARK LEAD AS CONTACTED (REAL-TIME UPDATE)
  Future<DateTime?> markAsContacted(int leadId) async {
    try {
      final response = await _networkRepository.markLeadAsContacted(
        data: {"LeadId": leadId},
      );

      if (response != null && response["Status"] == true) {
        final dateString = response["Data"]?["ContactedDate"];

        if (dateString != null) {
          final contactedDate = DateTime.tryParse(dateString);

          /// 🔥 UPDATE LIST IN REAL TIME
          final index = leadList.indexWhere((e) => e.id == leadId);
          if (index != -1) {
            leadList[index] = leadList[index].copyWith(
              isContacted: true,
              contactedDate: contactedDate,
            );
          }

          return contactedDate;
        }
      }
    } catch (e, stack) {
      await ErrorLogger.logErrorToServer(
        pageType: "LeadDetails",
        actionType: "MarkContacted",
        errorMessage1: e.toString(),
        errorMessage3: stack.toString(),
      );
    }
    return null;
  }
}
