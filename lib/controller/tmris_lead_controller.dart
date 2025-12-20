import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/tmris_lead_model.dart';
import '../service/network_repository.dart';
import '../service/error_logger.dart';

class TmrisLeadController extends GetxController {
  final NetworkRepository _repo = NetworkRepository();

  RxList<TmrisLeadModel> leadList = <TmrisLeadModel>[].obs;

  RxBool isLoading = false.obs;
  RxBool isPaginationLoading = false.obs;
  RxBool hasMoreData = true.obs;
  RxBool isArchivedTab = false.obs;

  int pageNumber = 1;
  final int pageSize = 10;

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    _setupScroll();
  }

  void _setupScroll() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 100 &&
          !isPaginationLoading.value &&
          hasMoreData.value) {
        loadMoreLeads();
      }
    });
  }

  Future<void> initialLoad() async {
    isLoading.value = true;
    await refreshLeads();
    isLoading.value = false;
  }

  Future<void> changeArchiveTab(bool archived) async {
    isArchivedTab.value = archived;
    await refreshLeads();
  }

  Future<void> refreshLeads() async {
    pageNumber = 1;
    hasMoreData.value = true;

    final list = await _fetchLeads();
    if (list != null) {
      leadList.assignAll(list);
    }
  }

  Future<void> loadMoreLeads() async {
    isPaginationLoading.value = true;
    pageNumber++;

    final list = await _fetchLeads();
    if (list != null) {
      leadList.addAll(list);
    }

    isPaginationLoading.value = false;
  }

  Future<List<TmrisLeadModel>?> _fetchLeads() async {
    try {
      final response = await _repo.getTmrisLeads(
        queryParameters: {
          "pageNumber": pageNumber,
          "pageSize": pageSize,
          "isArchived": isArchivedTab.value,
        },
      );

      if (response != null) {
        final model = tmrisLeadResponseFromJson(json.encode(response));

        if (model.status == true && model.data != null) {
          hasMoreData.value = pageNumber < (model.data!.totalPages ?? 1);
          return model.data!.leads ?? [];
        }
      }
    } catch (e, stack) {
      await ErrorLogger.logErrorToServer(
        pageType: "TMRISLeads",
        actionType: "Fetch",
        errorMessage1: e.toString(),
        errorMessage3: stack.toString(),
      );
    }
    return null;
  }

  Future<void> toggleArchive(int leadId, bool archive) async {
    try {
      final response = await _repo.archiveTmrisLead(
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
        pageType: "TMRISLeads",
        actionType: "Archive",
        errorMessage1: e.toString(),
        errorMessage3: stack.toString(),
      );
    }
  }
}
