import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'common_web_view.dart';

class DocumentViewerWidget extends StatefulWidget {
  final String filePath;
  final String? fileName;

  const DocumentViewerWidget({Key? key, required this.filePath, this.fileName})
      : super(key: key);

  @override
  _DocumentViewerWidgetState createState() => _DocumentViewerWidgetState();
}

class _DocumentViewerWidgetState extends State<DocumentViewerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 150));
    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 0.95).animate(_animationController);
  }

  String _getFileExtension(String url) {
    if (!url.contains('.')) return '';
    return url
        .split('.')
        .last
        .toLowerCase()
        .split('?')
        .first; // Handle query params in URL
  }

  IconData _getFileIcon(String filePath) {
    String ext = _getFileExtension(filePath);
    if (ext == 'pdf') return Icons.picture_as_pdf_rounded;
    if (['doc', 'docx'].contains(ext)) return Icons.description_rounded;
    if (['jpg', 'png', 'jpeg'].contains(ext)) return Icons.image_rounded;
    return Icons.insert_drive_file_rounded;
  }

  void _openDocument() {
    log("Opening document: ${widget.filePath}");
    _animationController.forward().then((_) => _animationController.reverse());
    Get.to(() => CommonWebView(
          url:
              "https://docs.google.com/gview?embedded=true&url=${widget.filePath}",
          title: widget.fileName ?? "Document",
        ));
  }

  void _showOptions(BuildContext context) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(16.sp),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.remove_red_eye, color: primaryColor),
                title: const Text("Preview Document"),
                onTap: () {
                  Navigator.pop(context);
                  _openDocument();
                },
              ),
              ListTile(
                leading: const Icon(Icons.open_in_browser, color: primaryBlack),
                title: const Text("Open in Browser"),
                onTap: () {
                  Navigator.pop(context);
                  launchURL(widget.filePath);
                },
              ),
              SizedBox(height: 20.h),
            ],
          ),
        );
      },
    );
  }

  void launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      log("Could not launch $url");
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Removed SafeArea as it's meant for screen-level widgets, not small cards.
    // Inside a 140.sp container, SafeArea would eat up too much space.
    return ScaleTransition(
      scale: _scaleAnimation,
      child: InkWell(
        onTap: _openDocument,
        onLongPress: () => _showOptions(context),
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          // Fill the 140.sp parent height
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            gradient: LinearGradient(
              colors: [
                primaryColor.withOpacity(.85),
                primaryBlack.withOpacity(.95)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // Centering fixes overflow math
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                _getFileIcon(widget.filePath),
                size: 45.sp, // Reduced slightly to prevent height collision
                color: Colors.white,
              ),
              SizedBox(height: 8.h),
              // FIX: Wrap text in Flexible or Expanded to prevent RenderFlex overflow
              Flexible(
                child: Text(
                  widget.fileName ?? "Open Document",
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
