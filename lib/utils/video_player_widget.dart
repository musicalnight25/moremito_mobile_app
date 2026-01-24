import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({super.key, required this.videoUrl});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;

  final VideoController videoController = Get.put(VideoController());
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    _videoController = VideoPlayerController.network(widget.videoUrl);

    await _videoController!.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoController!,
      autoPlay: true,
      looping: true,
      showControls: true,
      allowFullScreen: true,
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.redAccent,
        handleColor: Colors.white,
        backgroundColor: Colors.grey.shade600,
        bufferedColor: Colors.white54,
      ),
    );

    videoController.setActiveVideo(_videoController!);

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            /// Video or Loader
            Positioned.fill(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    )
                  : Chewie(controller: _chewieController!),
            ),

            /// Back Button
            Positioned(
              top: 12,
              left: 12,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Manages active video to avoid multiple playing
class VideoController extends GetxController {
  VideoPlayerController? currentVideo;

  void setActiveVideo(VideoPlayerController controller) {
    if (currentVideo != null && currentVideo != controller) {
      currentVideo!.pause();
    }
    currentVideo = controller;
  }

  @override
  void onClose() {
    currentVideo?.dispose();
    super.onClose();
  }
}
