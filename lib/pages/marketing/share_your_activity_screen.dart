import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controller/flyers_controller.dart';
import '../../model/search_users_for_share_model.dart';
import '../../utils/app_text_style.dart';
import '../../utils/base_background_widget.dart';
import '../../utils/colors.dart';
import '../../utils/common_app_bar.dart';
import '../../utils/static_decoration.dart';

class ShareYourActivityScreen extends StatefulWidget {
  const ShareYourActivityScreen({super.key});

  @override
  State<ShareYourActivityScreen> createState() =>
      _ShareYourActivityScreenState();
}

enum _ShareStep { search, confirm }

class _ShareYourActivityScreenState extends State<ShareYourActivityScreen> {
  final FlyersController controller = Get.isRegistered<FlyersController>()
      ? Get.find<FlyersController>()
      : Get.put(FlyersController());

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final RxnInt _noteLength = RxnInt(0);
  final RxBool _sharing = false.obs;

  // ──────────────────────────────────────────────────────────────
  // Step tracking — using Rx so Obx rebuilds when step changes
  // ──────────────────────────────────────────────────────────────
  final Rx<_ShareStep> _step = _ShareStep.search.obs;
  final Rxn<ShareUserItem> _selectedUser = Rxn<ShareUserItem>();

  @override
  void initState() {
    super.initState();
    controller.searchUserResults.clear();
    controller.searchUsersLoading.value = false;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _doSearch() {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;
    FocusScope.of(context).unfocus();
    controller.searchUsersForShare(query);
  }

  Future<void> _doShare() async {
    if (_selectedUser.value?.userId == null) return;
    _sharing.value = true;
    final success = await controller.saveReportShare(
      userId: _selectedUser.value!.userId!,
      note: _noteController.text.trim(),
    );
    _sharing.value = false;

    if (success) {
      Get.back();
      Get.snackbar(
        '✅ Report Shared',
        'Your activity has been shared with ${_selectedUser.value!.name ?? _selectedUser.value!.username}.',
        backgroundColor: primaryColor,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(16.sp),
        duration: const Duration(seconds: 3),
      );
    } else {
      Get.snackbar(
        'Could not share',
        'This report may already be shared with this user.',
        backgroundColor: Colors.orangeAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(16.sp),
        duration: const Duration(seconds: 4),
      );
    }
  }

  // ──────────────────────────────────────────────────────────────
  // STEP 1: Search UI
  // ──────────────────────────────────────────────────────────────
  Widget _buildSearchStep(bool loading, List<ShareUserItem> results) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        height10,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.sp),
          child: Text(
            'Share Your Activity',
            style: AppTextStyle.normalBold18.copyWith(color: primaryColor),
          ),
        ),
        height04,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.sp),
          child: Text(
            'Search for a user by username to share your\nShared Links Activity Tracking report with them.',
            style: AppTextStyle.normalRegular13
                .copyWith(color: subTitleColor, height: 1.4),
          ),
        ),
        height16,

        // ── Search row ──────────────────────────────────────────
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.sp),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) => _doSearch(),
                  decoration: InputDecoration(
                    labelText: 'Search by Username',
                    labelStyle: AppTextStyle.normalRegular13
                        .copyWith(color: subTitleColor),
                    hintText: 'Enter username',
                    hintStyle: AppTextStyle.normalRegular13
                        .copyWith(color: borderGreyColor),
                    prefixIcon: Icon(Icons.person_search_outlined,
                        color: primaryColor, size: 20.sp),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 14.sp, vertical: 12.sp),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(color: borderGreyColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(color: borderGreyColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide:
                          const BorderSide(color: primaryColor, width: 1.5),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.sp),
              ElevatedButton.icon(
                onPressed: loading ? null : _doSearch,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  disabledBackgroundColor: primaryColor.withOpacity(0.5),
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.sp, vertical: 14.sp),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r)),
                  elevation: 2,
                ),
                icon: loading
                    ? SizedBox(
                        width: 16.sp,
                        height: 16.sp,
                        child: const CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                      )
                    : Icon(Icons.search_rounded,
                        color: Colors.white, size: 18.sp),
                label: Text('Search',
                    style: AppTextStyle.normalBold14
                        .copyWith(color: Colors.white)),
              ),
            ],
          ),
        ),
        height16,

        // ── Results ─────────────────────────────────────────────
        if (loading)
          const Expanded(
            child: Center(
              child: CircularProgressIndicator(color: primaryColor),
            ),
          )
        else if (results.isEmpty)
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_search_outlined,
                      size: 60.sp, color: borderGreyColor),
                  height12,
                  Text(
                    'Enter a username and tap Search.',
                    style: AppTextStyle.normalRegular14
                        .copyWith(color: subTitleColor),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
        else ...[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.sp),
            child: Text(
              '${results.length} result(s)',
              style:
                  AppTextStyle.normalSemiBold13.copyWith(color: subTitleColor),
            ),
          ),
          height08,
          Expanded(
            child: ListView.builder(
              padding:
                  EdgeInsets.only(left: 16.sp, right: 16.sp, bottom: 16.sp),
              itemCount: results.length,
              itemBuilder: (_, i) {
                final user = results[i];
                final name = user.name ?? user.username ?? '';
                final initials = name
                    .split(' ')
                    .where((w) => w.isNotEmpty)
                    .take(2)
                    .map((w) => w[0].toUpperCase())
                    .join();

                return Container(
                  margin: EdgeInsets.only(bottom: 10.sp),
                  padding:
                      EdgeInsets.symmetric(horizontal: 14.sp, vertical: 12.sp),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: borderGreyColor),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Avatar initials
                      CircleAvatar(
                        radius: 22.r,
                        backgroundColor: primaryColor.withOpacity(0.12),
                        child: Text(
                          initials.isEmpty ? '?' : initials,
                          style: AppTextStyle.normalBold14
                              .copyWith(color: primaryColor),
                        ),
                      ),
                      SizedBox(width: 12.sp),
                      // Name + username + email
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: AppTextStyle.normalBold14
                                  .copyWith(color: primaryBlack),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 2.sp),
                            Text(
                              '@${user.username ?? ''}',
                              style: AppTextStyle.normalRegular12
                                  .copyWith(color: primaryColor),
                            ),
                            if (user.email?.isNotEmpty == true) ...[
                              SizedBox(height: 2.sp),
                              Text(
                                user.email!,
                                style: AppTextStyle.normalRegular11
                                    .copyWith(color: subTitleColor),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                      SizedBox(width: 8.sp),
                      // Choose button
                      GestureDetector(
                        onTap: () {
                          _selectedUser.value = user;
                          _noteController.clear();
                          _noteLength.value = 0;
                          _step.value = _ShareStep.confirm;
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 14.sp, vertical: 8.sp),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            'Choose',
                            style: AppTextStyle.normalBold12
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  // ──────────────────────────────────────────────────────────────
  // STEP 2: Confirm & share UI
  // ──────────────────────────────────────────────────────────────
  Widget _buildConfirmStep(ShareUserItem user, bool sharing, int noteLen) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          height10,
          Text('Share Report',
              style: AppTextStyle.normalBold18.copyWith(color: primaryColor)),
          height04,
          Text(
            'Review the selected user and optionally add a note before sharing.',
            style: AppTextStyle.normalRegular13
                .copyWith(color: subTitleColor, height: 1.4),
          ),
          height16,

          // ── Selected user card ────────────────────────────────
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.sp),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: primaryColor.withOpacity(0.3)),
              boxShadow: [
                BoxShadow(
                    color: primaryColor.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 3))
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selected User Details',
                  style: AppTextStyle.normalSemiBold13
                      .copyWith(color: subTitleColor),
                ),
                height08,
                const Divider(),
                height08,
                _detailRow('Name', user.name ?? '—'),
                height08,
                _detailRow('Username', '@${user.username ?? '—'}'),
                if (user.email?.isNotEmpty == true) ...[
                  height08,
                  _detailRow('Email', user.email!),
                ],
              ],
            ),
          ),
          height16,

          // ── Note field ────────────────────────────────────────
          Text('Note (Optional):',
              style:
                  AppTextStyle.normalSemiBold13.copyWith(color: primaryBlack)),
          height08,
          TextField(
            controller: _noteController,
            maxLines: 4,
            maxLength: 500,
            onChanged: (v) => _noteLength.value = v.length,
            decoration: InputDecoration(
              hintText: 'Enter a note (max 500 characters)',
              hintStyle:
                  AppTextStyle.normalRegular13.copyWith(color: borderGreyColor),
              filled: true,
              fillColor: Colors.white,
              counterText: '$noteLen/500 characters',
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 14.sp, vertical: 12.sp),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(color: borderGreyColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(color: borderGreyColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: const BorderSide(color: primaryColor, width: 1.5),
              ),
            ),
          ),
          height20,

          // ── Action buttons ────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    _step.value = _ShareStep.search;
                    _selectedUser.value = null;
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: primaryColor),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r)),
                    padding: EdgeInsets.symmetric(vertical: 13.sp),
                  ),
                  icon: Icon(Icons.arrow_back_rounded,
                      color: primaryColor, size: 16.sp),
                  label: Text('Different User',
                      style: AppTextStyle.normalSemiBold13
                          .copyWith(color: primaryColor)),
                ),
              ),
              SizedBox(width: 10.sp),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: sharing ? null : _doShare,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    disabledBackgroundColor: primaryColor.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r)),
                    padding: EdgeInsets.symmetric(vertical: 13.sp),
                    elevation: 2,
                  ),
                  icon: sharing
                      ? SizedBox(
                          width: 16.sp,
                          height: 16.sp,
                          child: const CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        )
                      : Icon(Icons.share_outlined,
                          color: Colors.white, size: 16.sp),
                  label: Text('Share Report',
                      style: AppTextStyle.normalBold14
                          .copyWith(color: Colors.white)),
                ),
              ),
            ],
          ),
          SizedBox(height: 30.sp),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────
  // HELPERS
  // ──────────────────────────────────────────────────────────────

  Widget _detailRow(String label, String value) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80.sp,
            child: Text('$label:',
                style: AppTextStyle.normalSemiBold13
                    .copyWith(color: subTitleColor)),
          ),
          Expanded(
            child: Text(value,
                style: AppTextStyle.normalSemiBold13
                    .copyWith(color: primaryBlack)),
          ),
        ],
      );

  // ──────────────────────────────────────────────────────────────
  // BUILD — single Obx wraps everything so any Rx change rebuilds
  // ──────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CommonAppBar(
        title: 'Share Report',
        visibleBackButton: true,
      ),
      body: BaseBackgroundWidget(
        child: Obx(() {
          final loading = controller.searchUsersLoading.value;
          final results = controller.searchUserResults.toList();
          final step = _step.value;
          final user = _selectedUser.value;
          final sharing = _sharing.value;
          final noteLen = _noteLength.value ?? 0;

          if (step == _ShareStep.confirm && user != null) {
            return _buildConfirmStep(user, sharing, noteLen);
          }
          return _buildSearchStep(loading, results);
        }),
      ),
    );
  }
}
