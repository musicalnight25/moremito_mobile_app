import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:more_mitro_app/utils/colors.dart';

import 'app_text_style.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String audioUrl;

  const AudioPlayerWidget({Key? key, required this.audioUrl}) : super(key: key);

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget>
    with SingleTickerProviderStateMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool isPlaying = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    _audioPlayer.onPositionChanged.listen((Duration p) {
      setState(() => _position = p);
    });

    _audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() => _duration = d);
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        isPlaying = false;
        _animationController.reverse();
      });
    });
  }

  void _togglePlayPause() async {
    if (isPlaying) {
      await _audioPlayer.pause();
      _animationController.reverse();
    } else {
      await _audioPlayer.play(UrlSource(widget.audioUrl));
      _animationController.forward();
    }
    setState(() => isPlaying = !isPlaying);
  }

  void _seekTo(Duration position) async {
    await _audioPlayer.seek(position);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _animationController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds.remainder(60))}";
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              primaryColor.withOpacity(.8),
              primaryBlack.withOpacity(.9)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SliderTheme(
              data: SliderThemeData(
                trackHeight: 4.h,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.r),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 12.r),
              ),
              child: Slider(
                min: 0,
                max: _duration.inSeconds.toDouble(),
                value: _position.inSeconds.toDouble(),
                onChanged: (value) => _seekTo(Duration(seconds: value.toInt())),
                activeColor: Colors.white,
                inactiveColor: Colors.white38,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_formatDuration(_position),
                      style: AppTextStyle.normalBold14
                          .copyWith(color: Colors.white)),
                  Text(_formatDuration(_duration),
                      style: AppTextStyle.normalBold14
                          .copyWith(color: Colors.white)),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            GestureDetector(
              onTap: _togglePlayPause,
              child: Container(
                padding: EdgeInsets.all(8.sp),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryWhite.withOpacity(.8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      spreadRadius: 2,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: AnimatedIcon(
                  icon: AnimatedIcons.play_pause,
                  progress: _animationController,
                  size: 36.sp,
                  color: primaryBlack,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
