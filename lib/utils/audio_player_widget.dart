import 'dart:async';
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
  late AudioPlayer _audioPlayer;
  late AnimationController _animationController;

  Duration _duration = Duration.zero;
  bool _isSourceSet = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _audioPlayer = AudioPlayer();

    // Set global context only once
    _setupGlobalAudio();
    _initSource();
  }

  void _setupGlobalAudio() {
    AudioPlayer.global.setAudioContext(AudioContext(
      iOS: AudioContextIOS(category: AVAudioSessionCategory.playback),
      android: AudioContextAndroid(usageType: AndroidUsageType.media),
    ));
  }

  Future<void> _initSource() async {
    try {
      // Use 'Source' instead of 'setSource' directly to let it buffer in the background
      await _audioPlayer.setSourceUrl(widget.audioUrl);

      _audioPlayer.onDurationChanged.listen((d) {
        if (mounted) setState(() => _duration = d);
      });

      _audioPlayer.onPlayerStateChanged.listen((state) {
        if (mounted) {
          state == PlayerState.playing
              ? _animationController.forward()
              : _animationController.reverse();
        }
      });

      _isSourceSet = true;
    } catch (e) {
      debugPrint("Instant load error: $e");
    }
  }

  void _togglePlayPause() async {
    if (_audioPlayer.state == PlayerState.playing) {
      await _audioPlayer.pause();
    } else {
      // Calling resume on a pre-set source is the fastest way to start
      await _audioPlayer.resume();
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _animationController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: primaryColor.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          // THE PLAY BUTTON
          GestureDetector(
            onTap: _togglePlayPause,
            child: Container(
              height: 40.sp,
              width: 40.sp,
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: AnimatedIcon(
                  icon: AnimatedIcons.play_pause,
                  progress: _animationController,
                  size: 22.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),

          // THE SLIDER & POSITION
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StreamBuilder<Duration>(
                  stream: _audioPlayer.onPositionChanged,
                  builder: (context, snapshot) {
                    final position = snapshot.data ?? Duration.zero;
                    double max = _duration.inSeconds.toDouble();
                    double value = position.inSeconds.toDouble();

                    if (value > max) value = max;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 3.h,
                            thumbShape:
                                RoundSliderThumbShape(enabledThumbRadius: 5.r),
                            overlayShape:
                                RoundSliderOverlayShape(overlayRadius: 12.r),
                            activeTrackColor: primaryColor,
                            inactiveTrackColor: primaryColor.withOpacity(0.1),
                            thumbColor: primaryColor,
                            padding: EdgeInsets.zero,
                          ),
                          child: Slider(
                            min: 0,
                            max: max > 0 ? max : 1.0,
                            value: value,
                            onChanged: (v) {
                              _audioPlayer.seek(Duration(seconds: v.toInt()));
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 4.w),
                          child: Text(
                            _formatDuration(position),
                            style: AppTextStyle.normalRegular10.copyWith(
                              color: hintGreyColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
