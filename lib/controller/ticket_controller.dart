import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/service/network_repository.dart';
import 'package:dio/dio.dart' as d;

// ==================== MODEL IMPORTS (YOU WILL CREATE THESE) ====================
import 'package:more_mitro_app/model/ticket_list_model.dart';
import 'package:more_mitro_app/model/ticket_priority_model.dart';
import 'package:more_mitro_app/model/ticket_modules_model.dart';
import 'package:more_mitro_app/model/ticket_detail_model.dart';
import 'package:more_mitro_app/model/create_ticket_model.dart';
import 'package:more_mitro_app/model/ticket_comment_add_model.dart';

import '../utils/colors.dart';
import '../utils/common_method.dart';

class TicketController extends GetxController {
  final NetworkRepository _repo = NetworkRepository();

  // ==================== LIST ====================
  RxBool listLoading = false.obs;
  RxList<TicketModel> ticketList = <TicketModel>[].obs;

  // ==================== PRIORITY LIST ====================
  RxBool priorityLoading = false.obs;
  RxList<TicketPriorityModel> priorityList = <TicketPriorityModel>[].obs;

  // ==================== MODULES LIST ====================
  RxBool moduleLoading = false.obs;
  RxList<TicketModuleModel> moduleList = <TicketModuleModel>[].obs;

  // ==================== DETAILS ====================
  RxBool detailLoading = false.obs;
  Rxn<TicketDetailResponseData> ticketDetail = Rxn<TicketDetailResponseData>();

  // ==================== CREATE ====================
  RxBool createLoading = false.obs;

  // ==================== COMMENT ====================
  RxBool commentLoading = false.obs;

  // ==================== INIT ====================
  @override
  void onInit() {
    super.onInit();
    // Optionally auto-load ticket list
    // WidgetsBinding.instance.addPostFrameCallback((_) => getTicketList());
  }

  // ===========================================================================
  //                          GET SUPPORT TICKET LIST
  // ===========================================================================
  Future<void> getTicketList({int sortBy = 0, int filter = 0}) async {
    listLoading.value = true;

    try {
      var response =
          await _repo.getSupportTickets(null, sortBy: sortBy, filter: filter);
      if (response != null) {
        final model = ticketListResponseFromJson(json.encode(response));

        if (model.status == true) {
          ticketList.value = model.data ?? [];
        }
      }
    } catch (e) {
      debugPrint("Error in getTicketList: $e");
    } finally {
      listLoading.value = false;
    }
  }

  // ===========================================================================
  //                         GET TICKET PRIORITY LIST
  // ===========================================================================
  Future<void> getTicketPriorities() async {
    priorityLoading.value = true;

    try {
      var response = await _repo.getTicketPriorities(null);
      if (response != null) {
        final model = ticketPriorityResponseFromJson(json.encode(response));
        if (model.status == true) {
          priorityList.value = model.data ?? [];
        }
      }
    } catch (e) {
      debugPrint("Error in getTicketPriorities: $e");
    } finally {
      priorityLoading.value = false;
    }
  }

  // ===========================================================================
  //                         GET TICKET MODULE LIST
  // ===========================================================================
  Future<void> getTicketModules() async {
    moduleLoading.value = true;

    try {
      var response = await _repo.getTicketModules(null);
      if (response != null) {
        final model = ticketModulesResponseFromJson(json.encode(response));
        if (model.status == true) {
          moduleList.value = model.data ?? [];
        }
      }
    } catch (e) {
      debugPrint("Error in getTicketModules: $e");
    } finally {
      moduleLoading.value = false;
    }
  }

  // ===========================================================================
  //                        GET TICKET DETAILS + COMMENTS
  // ===========================================================================
  Future<void> getTicketDetails(var ticketId) async {
    detailLoading.value = true;

    try {
      var response = await _repo.getTicketComments(null, ticketId);
      if (response != null) {
        final model = ticketDetailResponseFromJson(json.encode(response));

        if (model.status == true) {
          ticketDetail.value = model.data;
        }
      }
    } catch (e) {
      debugPrint("Error in getTicketDetails: $e");
    } finally {
      detailLoading.value = false;
    }
  }

  // ===========================================================================
  //                              CREATE SUPPORT TICKET
  // ===========================================================================
  Future<int?> createTicket({
    required String title,
    required String description,
    required int priorityId,
    required int moduleId,
    List<String>? files, // file paths
  }) async {
    createLoading.value = true;

    try {
      /// BUILD MULTIPART FORM DATA
      final formData = d.FormData.fromMap({
        "TicketTitle": title,
        "TicketDescription": description,
        "TicketPriority": priorityId,
        "TicketType": moduleId,
        if (files != null)
          "files": [
            for (var path in files)
              await d.MultipartFile.fromFile(path,
                  filename: path.split("/").last),
          ],
      });
      var response = await _repo.createSupportTicket(null, formData);

      if (response != null) {
        Get.back();
        CommonMethod.getXSnackBar("Success".tr, "Ticket created successfully.".tr, primaryColor);

        getTicketList();
      }
    } catch (e) {
      debugPrint("Error in createTicket: $e");
    } finally {
      createLoading.value = false;
    }

    return null;
  }

  // ===========================================================================
  //                              ADD COMMENT
  // ===========================================================================
  Future<bool> addComment({
    required int ticketId,
    required String comment,
    List<String>? files, // file paths
  }) async {
    commentLoading.value = true;

    try {
      final formData = d.FormData.fromMap({
        "TicketId": ticketId,
        "TicketComment": comment,
        if (files != null)
          "files": [
            for (var path in files)
              await d.MultipartFile.fromFile(path,
                  filename: path.split("/").last),
          ],
      });
      var response = await _repo.addTicketComment(null, formData);

      if (response != null) {
        CommonMethod.getXSnackBar("Success".tr, "Ticket reopened".tr, primaryColor);
        getTicketList();
        await getTicketDetails(ticketId); // refresh
      }
    } catch (e) {
      debugPrint("Error in addComment: $e");
    } finally {
      commentLoading.value = false;
    }

    return false;
  }
}
