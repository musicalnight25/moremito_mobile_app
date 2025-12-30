import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/model/category_file_model.dart';
import 'package:more_mitro_app/utils/app_text_style.dart';
import 'package:more_mitro_app/utils/shadow_container_widget.dart';

import '../document_viewer_screen.dart';

class CategoryFileTile extends StatelessWidget {
  final CategoryFileModel data;

  const CategoryFileTile({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final bool isAudio = data.filePath != null &&
        (GetUtils.isAudio(data.filePath!) ||
            data.filePath!.toLowerCase().endsWith('.m4a'));

    final bool isVideo =
        data.filePath != null && GetUtils.isVideo(data.filePath!);

    final bool isImage =
        data.filePath != null && GetUtils.isImage(data.filePath!);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: ShadowContainerWidget(
        radius: 14,
        borderWidth: 1,
        widget: InkWell(
          onTap: () {
            Get.to(() => DocumentViewerScreen(data: data));
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                isVideo
                    ? CupertinoIcons.video_camera
                    : isImage
                        ? Icons.photo_outlined
                        : isAudio
                            ? CupertinoIcons.music_note_2
                            : CupertinoIcons.doc_text,
                size: 28,
              ),
              const SizedBox(width: 12),

              /// File name (expandable)
              Expanded(
                child: Text(
                  data.fileName ?? "",
                  style: AppTextStyle.normalBold14,
                  softWrap: true,
                  // maxLines: 4, // 👈 allows longer filenames
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              const SizedBox(width: 10),

              Icon(
                isVideo || isAudio
                    ? CupertinoIcons.play_circle
                    : CupertinoIcons.eye,
                size: 26,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
