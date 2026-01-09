import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// Adjust imports to match your project
import '../../controller/shop_moremito_controller.dart';
import '../../utils/app_text_style.dart';
import '../../utils/base_background_widget.dart';
import '../../utils/colors.dart';
import '../../utils/common_app_bar.dart';

class ShopMoremitoScreen extends StatelessWidget {
  const ShopMoremitoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize Controller
    final ShopMoremitoController controller = Get.put(ShopMoremitoController());

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CommonAppBar(
        visibleBackButton: true,
      ),
      body: Stack(
        children: [
          // 1. Main Content
          BaseBackgroundWidget(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // People Health Products Banner
                  _buildHealthBanner(
                    title: "People Health\nProducts",
                    subText: "Buy Now",
                    imageUrl:
                        "https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?auto=format&fit=crop&w=800&q=80",
                    onTap: () {
                      controller.getWebViewToken("PeopleHealthProducts");
                    },
                  ),

                  SizedBox(height: 24.h),

                  // Pet Health Products Banner
                  _buildHealthBanner(
                    title: "Pet Health\nProducts",
                    subText: "Shop Now",
                    imageUrl:
                        "https://images.unsplash.com/photo-1623387641168-d9803ddd3f35?auto=format&fit=crop&w=800&q=80",
                    onTap: () {
                      controller.getWebViewToken("PetHealthProducts");
                    },
                    isPetBanner: true,
                  ),
                ],
              ),
            ),
          ),

          // 2. Loading Overlay (Shows only when isLoading is true)
          Obx(() {
            return controller.isLoading.value
                ? Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: Colors.black.withOpacity(0.5), // Dim background
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white, // White loader
                      ),
                    ),
                  )
                : const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildHealthBanner({
    required String title,
    required String subText,
    required String imageUrl,
    required VoidCallback onTap,
    bool isPetBanner = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 180.h,
        decoration: BoxDecoration(
          color: const Color(0xFFAEDB3D),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFAEDB3D).withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: CustomPaint(
                  painter: _CirclePatternPainter(),
                ),
              ),
            ),
            Positioned(
              right: isPetBanner ? -10.w : -20.w,
              bottom: 0,
              top: 0,
              width: 180.w,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.r),
                  bottomRight: Radius.circular(20.r),
                  bottomLeft: Radius.circular(100.r),
                ),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.white.withOpacity(0.5),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 20.w, top: 20.h, bottom: 20.h, right: 150.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: AppTextStyle.normalBold20.copyWith(
                      color: Colors.black,
                      fontSize: 24.sp,
                      height: 1.1,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          subText.toUpperCase(),
                          style: AppTextStyle.normalSemiBold14.copyWith(
                            color: Colors.black,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 16.sp,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CirclePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width * 0.1, size.height * 0.2), 40, paint);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.9), 80, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
