import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/rank_info_controller.dart';
import '../../utils/common_app_bar.dart';

// Make sure to import your colors file correctly
import '../../utils/colors.dart';

class RankInfoScreen extends StatelessWidget {
  const RankInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RankInfoController());

    return Scaffold(
      backgroundColor: primaryWhite, // Clean white background
      appBar: const CommonAppBar(
        title: "My Rank History",
        visibleBackButton: true,
      ),
      body: Column(
        children: [
          // 1. The Header Section
          _buildTableHeader(),

          // 2. The List Section
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                    child: CircularProgressIndicator(color: primaryColor));
              }

              final data = controller.rankInfo.value;
              if (data == null ||
                  data.rankHistory == null ||
                  data.rankHistory!.isEmpty) {
                return _buildEmptyState();
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: data.rankHistory!.length,
                separatorBuilder: (context, index) => const Divider(
                    height: 1,
                    color: borderGreyColor,
                    indent: 16,
                    endIndent: 16),
                itemBuilder: (context, i) {
                  final item = data.rankHistory![i];
                  return _buildRankRow(item, i);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  // --- Widget Builders ---

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: paleYellowColor,
        // Using your paleYellow (or mintGreen) for a soft header bg
        border: const Border(
          bottom: BorderSide(color: borderGreyColor),
        ),
      ),
      child: Row(
        children: [
          _buildHeaderText("Date", flex: 3),
          _buildHeaderText("Order No.", flex: 2, textAlign: TextAlign.center),
          _buildHeaderText("Rank", flex: 3, textAlign: TextAlign.end),
        ],
      ),
    );
  }

  Widget _buildHeaderText(String text,
      {int flex = 1, TextAlign textAlign = TextAlign.start}) {
    return Expanded(
      flex: flex,
      child: Text(
        text.toUpperCase(),
        textAlign: textAlign,
        style: const TextStyle(
          color: lightBlackColor,
          fontWeight: FontWeight.w700,
          fontSize: 12,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildRankRow(dynamic item, int index) {
    // Helper to handle null or empty strings nicely
    String date = item.date ?? "-";
    // Optional: Format date here if needed, e.g., trim the time part
    if (date.contains(" ")) {
      date = date.split(" ")[0]; // Just shows YYYY-MM-DD
    }

    final String orderNo = (item.orderNo != null && item.orderNo!.isNotEmpty)
        ? item.orderNo!
        : "-";
    final String rank = item.rank ?? "Unknown";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      color: Colors.transparent,
      // Keeps the ripple effect if you add InkWell later
      child: Row(
        children: [
          // Date Column
          Expanded(
            flex: 3,
            child: Text(
              date,
              style: const TextStyle(
                color: subTitleColor,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Order No Column
          Expanded(
            flex: 2,
            child: Text(
              orderNo,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: orderNo == "-" ? hintGreyColor : primaryColor,
                // Highlight order numbers
                fontSize: 13,
                fontWeight:
                    orderNo == "-" ? FontWeight.normal : FontWeight.w600,
              ),
            ),
          ),

          // Rank Column
          Expanded(
            flex: 3,
            child: Text(
              rank,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: lightBlackColor,
                fontSize: 14,
                fontWeight: FontWeight.bold, // Rank is the most important info
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.history, size: 48, color: disableButtonColor),
          const SizedBox(height: 12),
          Text(
            "No rank history found",
            style: TextStyle(
              color: greySubTitleColor,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
