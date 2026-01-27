import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/utils/network_image_widget.dart';

// Adjust imports to match your project
import '../../controller/shop_moremito_controller.dart';
import '../../utils/app_text_style.dart';
import '../../utils/base_background_widget.dart';
import '../../utils/common_app_bar.dart';

class ShopMoremitoScreen extends StatelessWidget {
  const ShopMoremitoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ShopMoremitoController controller = Get.put(ShopMoremitoController());

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CommonAppBar(
        visibleBackButton: true,
      ),
      body: BaseBackgroundWidget(
        child: SingleChildScrollView(
          // Adjusted top padding to prevent content from hiding under AppBar
          padding:
              EdgeInsets.only(left: 16.w, right: 16.w, top: 20.h, bottom: 20.h),
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              _buildHealthBanner(
                title: "People Health\nProducts",
                subText: "Buy Now",
                imageUrl:
                    "https://moremito.com/Images/thumbnail/bb-bundle-1.jpeg",
                onTap: () =>
                    controller.getShopMoremitoWebview("PeopleHealthProducts"),
              ),
              SizedBox(height: 16.h),
              _buildHealthBanner(
                title: "Pet Health\nProducts",
                subText: "Buy Now",
                imageUrl: "https://moremito.com/Images/thumbnail/pet-life.jpeg",
                onTap: () =>
                    controller.getShopMoremitoWebview("PetHealthProducts"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHealthBanner({
    required String title,
    required String subText,
    required String imageUrl,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 180.h,
        decoration: BoxDecoration(
          // Using a slight gradient for a more "premium" feel
          gradient: const LinearGradient(
            colors: [Color(0xFFAEDB3D), Color(0xFFB9E54E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFAEDB3D).withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Artistic Background Circles
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28.r),
                child: CustomPaint(painter: _CirclePatternPainter()),
              ),
            ),

            Row(
              children: [
                // Left Content
                Expanded(
                  flex: 11,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: AppTextStyle.normalBold20.copyWith(
                            color: Colors.black.withOpacity(0.9),
                            fontSize: 22.sp,
                            height: 1.1,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        // Enhanced Button Look
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              )
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                subText.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              SizedBox(width: 6.w),
                              Icon(Icons.arrow_forward_ios_rounded,
                                  size: 10.sp, color: Colors.black),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Right Image Section
                Expanded(
                  flex: 9,
                  child: Stack(
                    children: [
                      // Curved Image Container with Inner Shadow/Gradient
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(28.r),
                            bottomRight: Radius.circular(28.r),
                            bottomLeft: Radius.circular(100.r),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(28.r),
                            bottomRight: Radius.circular(28.r),
                            bottomLeft: Radius.circular(100.r),
                          ),
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(12
                                  .w), // Padding ensures 'contain' doesn't hit edges
                              child: NetworkImageWidget(
                                imageUrl: imageUrl,
                                height: double.infinity,
                                width: double.infinity,
                                fit: BoxFit.contain, // As requested
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
      ..color = Colors.white.withOpacity(0.18)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width * 0.1, size.height * 0.2), 30.r, paint);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.8), 50.r, paint);
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.1), 20.r, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
