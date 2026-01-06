import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
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
  late AnimationController _playPauseController;

  // Stream subscriptions
  StreamSubscription<PlayerState>? _playerStateSubscription;
  StreamSubscription<Duration?>? _durationSubscription;
  StreamSubscription<Duration>? _positionSubscription;

  // State variables for UI
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isBuffering = false;

  @override
  void initState() {
    super.initState();
    _playPauseController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _audioPlayer = AudioPlayer();
    _initAudio();
  }

  Future<void> _initAudio() async {
    try {
      // 1. Listen to Player State (Playing/Paused/Buffering)
      _playerStateSubscription = _audioPlayer.playerStateStream.listen((state) {
        if (mounted) {
          // Sync Play/Pause Icon
          if (state.playing) {
            _playPauseController.forward();
          } else {
            _playPauseController.reverse();
          }

          // Handle Buffering Logic for the Spinner
          final processingState = state.processingState;
          if (processingState == ProcessingState.loading ||
              processingState == ProcessingState.buffering) {
            setState(() => _isBuffering = true);
          } else {
            setState(() => _isBuffering = false);
          }
        }
      });

      // 2. Listen to Duration (Total Length)
      _durationSubscription = _audioPlayer.durationStream.listen((duration) {
        setState(() => _duration = duration ?? Duration.zero);
      });

      // 3. Listen to Position (Current Time)
      _positionSubscription = _audioPlayer.positionStream.listen((position) {
        setState(() => _position = position);
      });

      // 4. Load Audio Source
      await _audioPlayer.setUrl(widget.audioUrl);
    } catch (e) {
      debugPrint("Audio Initialization Error: $e");
    }
  }

  void _togglePlayPause() async {
    if (_audioPlayer.playing) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
  }

  void _seek(double value) {
    _audioPlayer.seek(Duration(seconds: value.toInt()));
  }

  @override
  void dispose() {
    _playerStateSubscription?.cancel();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _audioPlayer.dispose();
    _playPauseController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}";
  }

  @override
  Widget build(BuildContext context) {
    // Calculate slider values
    double maxDuration = _duration.inSeconds.toDouble();
    double currentPosition = _position.inSeconds.toDouble();
    if (maxDuration <= 0) maxDuration = 1.0;
    if (currentPosition > maxDuration) currentPosition = maxDuration;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // --- PLAY / PAUSE / LOADING BUTTON ---
          GestureDetector(
            onTap: _togglePlayPause,
            child: Container(
              height: 48.sp,
              width: 48.sp,
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Center(
                child: _isBuffering
                    ? SizedBox(
                        height: 20.sp,
                        width: 20.sp,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : AnimatedIcon(
                        icon: AnimatedIcons.play_pause,
                        progress: _playPauseController,
                        size: 28.sp,
                        color: Colors.white,
                      ),
              ),
            ),
          ),

          SizedBox(width: 14.w),

          // --- SLIDER & TIMESTAMPS ---
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // The Slider
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 4.h,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.r),
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 14.r),
                    activeTrackColor: primaryColor,
                    inactiveTrackColor: primaryColor.withOpacity(0.15),
                    thumbColor: primaryColor,
                    overlayColor: primaryColor.withOpacity(0.1),
                  ),
                  child: Slider(
                    min: 0,
                    max: maxDuration,
                    value: currentPosition,
                    onChanged: (val) {
                      // Optional: optimistically update UI while dragging
                      setState(() {
                        _position = Duration(seconds: val.toInt());
                      });
                    },
                    onChangeEnd: (val) {
                      _seek(val);
                    },
                  ),
                ),

                // The Time Labels (Left & Right)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(_position),
                        style: AppTextStyle.normalRegular10.copyWith(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600,
                            fontSize: 11.sp),
                      ),
                      Text(
                        _formatDuration(_duration),
                        style: AppTextStyle.normalRegular10.copyWith(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600,
                            fontSize: 11.sp),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
