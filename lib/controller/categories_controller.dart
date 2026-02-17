import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
// import 'package:share_plus/share_plus.dart';

import '../model/categories_model.dart';
import '../model/category_file_model.dart';
import '../service/network_repository.dart';
import '../share_bottom_sheet.dart';
import '../utils/colors.dart';
import '../utils/common_method.dart';

class CategoriesController extends GetxController {
  final NetworkRepository _networkRepository = NetworkRepository();

  RxList<CategoryModel> categoriesList = <CategoryModel>[].obs;
  RxList<CategoryFileModel> categoriesFileList = <CategoryFileModel>[].obs;
  RxList<CategoryModel> subCategoriesList = <CategoryModel>[].obs;
  RxBool isLoading = false.obs;
  RxBool hasMore = true.obs;
  int _page = 1;
  RxString searchText = ''.obs;
  RxBool isGlobalSearch = false.obs;
  RxString globalSearchText = ''.obs;

  Future<void> getCategoriesList(BuildContext context) async {
    isLoading.value = true;
    try {
      final response = await _networkRepository.getCategoriesList();
      if (response != null) {
        final model = CategoryResponseModel.fromJson(response);
        if (model.status == true) {
          categoriesList.value = model.data ?? [];
        }
      }
    } catch (e) {
      debugPrint("Error in getCategoriesList: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getSubCategories(
      BuildContext? context, String categoryID) async {
    isLoading.value = true;
    try {
      final response =
          await _networkRepository.getSubCategories(context, categoryID);
      if (response != null) {
        final model = CategoryResponseModel.fromJson(response);
        if (model.status == true) {
          subCategoriesList.value = model.data ?? [];
        }
      }
    } catch (e) {
      debugPrint("Error in getSubCategories: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getSubCategoriesFiles(
    BuildContext? context,
    String subCategoryId, {
    String? searchText,
    bool loadMore = false,
  }) async {
    if (isLoading.value) return;

    if (!loadMore) {
      _page = 1;
      categoriesFileList.clear();
      hasMore.value = true;
    }

    isLoading.value = true;

    try {
      final response = await _networkRepository.getSubCategoriesFiles(
        context,
        subCategoryId,
        searchText: searchText,
        pageNumber: _page,
      );

      final model = CategoryFileResponseModel.fromJson(response);

      if (model.data != null) {
        categoriesFileList.addAll(model.data!.files);
        hasMore.value = model.data!.hasMore;

        if (model.data!.hasMore) {
          _page++;
        }
      }
    } catch (e) {
      debugPrint("getSubCategoriesFiles error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void globalSearchFiles(String? searchText) {
    isGlobalSearch.value = searchText != null && searchText.isNotEmpty;
    globalSearchText.value = searchText ?? '';

    getSubCategoriesFiles(
      null,
      "", // ✅ SubCategoryId MUST be null/empty
      searchText: searchText,
      loadMore: false,
    );
  }

  void resetGlobalSearch() {
    isGlobalSearch.value = false;
    globalSearchText.value = '';
    categoriesFileList.clear();
  }

  void resetAndSearch(String? text, String subCategoryId) {
    searchText.value = text ?? "";

    _page = 1;
    categoriesFileList.clear();
    hasMore.value = true;
    getSubCategoriesFiles(null, subCategoryId, searchText: text);
  }

  Future<void> mobileSaveFileShare({
    required BuildContext context,
    required String fileId,
    required String sharedBy,
    required String sharedUrl,
  }) async {
    try {
      var data = {
        "FileId": fileId,
        "SharedBy": sharedBy,
        "SharedUrl": sharedUrl
      };
      var response =
          await _networkRepository.mobileSaveFileShare(context, data);
      if (response != null) {}
    } catch (e) {
      print("Error in mobileSaveFileShare: $e");
    }
  }

  Future<String?> generateLink({
    required BuildContext context,
    required String fileId,
    required String SharedTo,
  }) async {
    try {
      var data = {"FileId": fileId, "SharedTo": SharedTo};
      var response = await _networkRepository.generateLink(context, data);
      if (response != null && response['Data'] != null) {
        return response['Data'];
      }
    } catch (e) {
      print("Error in generateLink: $e");
    }
    return null;
  }

  Future<void> shareFileUsingBottomSheet({
    required BuildContext context,
    required CategoryFileModel data,
    required String message,
    required String sharedUrl,
    required String phoneNumber,
    String? email,
  }) async {
    ShareBottomSheet.show(
      context: context,
      phoneNumber: phoneNumber,
      message: message,
      email: email,
      onShared: (platform) async {
        await mobileSaveFileShare(
          context: context,
          fileId: data.id.toString(),
          sharedUrl: sharedUrl,
          sharedBy: platform,
        );

        CommonMethod.getXSnackBar(
          "Success 🎉",
          "Thanks for sharing via $platform",
          greenColor,
        );
      },
    );
  }
}
