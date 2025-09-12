// import 'package:extended_image/extended_image.dart';
import 'dart:developer';
import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:more_mitro_app/utils/colors.dart';

// checkImageLoadState(ExtendedImageState state) {
//   switch (state.extendedImageLoadState) {
//     case LoadState.completed:
//       // print("Image Load completely");
//       return null;
//     case LoadState.loading:
//       // print("Image Still Loading...");
//       return CupertinoActivityIndicator();

//     case LoadState.failed:
//       // print("Image Load Failed");
//       return SvgPicture.asset(
//         AppAsset.logo,
//         fit: BoxFit.cover,
//         color: appColor,
//         alignment: Alignment.center,
//         // height: 50,
//         // width: 50,
//       );
//   }
// }

class NetworkImageWidget extends StatelessWidget {
  final String? imageUrl;
  final double? height;
  final double? width;
  final Color? color;
  final BoxFit? fit;
  final BorderRadius? borderRadius;

  const NetworkImageWidget({
    Key? key,
    this.height,
    this.width,
    this.color,
    this.fit,
    this.imageUrl,
    this.borderRadius = BorderRadius.zero,
  }) : super(key: key);

  static Map? header;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius!,
      child: new CachedNetworkImage(
          fit: fit ?? BoxFit.cover,
          height: height,
          // httpHeaders: NetworkHttp.getHeaders(),
          // maxHeightDiskCache: 100,
          // maxWidthDiskCache: (Get.width * 0.4).toInt(),
          // memCacheHeight: 500,
          // memCacheWidth: (Get.width * 0.4).toInt(),
          cacheKey: imageUrl,
          width: width,
          color: color,
          useOldImageOnUrlChange: true,
          imageUrl: imageUrl ??
              "https://images.unsplash.com/photo-1686177991278-b7a3c37739d4?q=80&w=2080&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
          progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                child: Lottie.asset(
                  'assets/json/loader.json',
                  height: 100,
                  width: 100,
                ),
              ),
          errorWidget: (context, url, error) {
            log("image Widget load error $error");
            return const Icon(Icons.error, color: primaryBlack);
          }),
    );
  }
}
