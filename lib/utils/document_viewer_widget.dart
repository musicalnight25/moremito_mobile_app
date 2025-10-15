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
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150));
    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 0.95).animate(_animationController);
  }

  String _getFileExtension(String url) {
    return url.split('.').last.toLowerCase();
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
                title: Text("Preview Document"),
                onTap: () {
                  Navigator.pop(context);
                  _openDocument();
                },
              ),
              ListTile(
                leading: Icon(Icons.open_in_browser, color: primaryBlack),
                title: Text("Open in Browser"),
                onTap: () {
                  Navigator.pop(context);
                  launchURL(widget.filePath);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
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
    return SafeArea(
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: InkWell(
          onTap: _openDocument,
          onLongPress: () => _showOptions(context),
          borderRadius: BorderRadius.circular(16.r),
          child: Container(
            padding: EdgeInsets.all(16.sp),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              gradient: LinearGradient(
                colors: [
                  primaryColor.withOpacity(.8),
                  primaryBlack.withOpacity(.9)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  spreadRadius: 2,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getFileIcon(widget.filePath),
                  size: 60.sp,
                  color: Colors.white,
                ),
                SizedBox(height: 8.h),
                Text(
                  widget.fileName ?? "Open Document",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
