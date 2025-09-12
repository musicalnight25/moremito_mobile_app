import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerWidget({super.key, required this.videoUrl});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  final VideoController videoController = Get.put(VideoController());
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl)
      ..addListener(() {
        if (_videoPlayerController != null &&
            _videoPlayerController!.value.isPlaying) {
          videoController.setActiveVideo(_videoPlayerController!);
        }
      })
      ..setLooping(true);

    await _videoPlayerController?.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController!,
      autoPlay: false,
      looping: true,
      showControls: true,
      allowFullScreen: true,
      autoInitialize: true,
    );

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading ||
        _chewieController == null ||
        !_videoPlayerController!.value.isInitialized) {
      return _buildShimmerEffect();
    }
    return Chewie(controller: _chewieController!);
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: double.infinity,
        height: 200, // Adjust height as needed
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

class VideoController extends GetxController {
  VideoPlayerController? currentVideo;

  void setActiveVideo(VideoPlayerController controller) {
    if (currentVideo != null && currentVideo != controller) {
      currentVideo?.pause();
    }
    currentVideo = controller;
  }

  @override
  void onClose() {
    currentVideo?.dispose();
    super.onClose();
  }
}
