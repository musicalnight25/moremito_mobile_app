import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:more_mitro_app/utils/colors.dart';
import 'app_text_style.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String audioUrl;

  const AudioPlayerWidget({super.key, required this.audioUrl});

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget>
    with SingleTickerProviderStateMixin {
  late final AudioPlayer _player;
  late final AnimationController _iconController;

  Duration _duration = Duration.zero;
  bool _isBuffering = false;

  @override
  void initState() {
    super.initState();

    _player = AudioPlayer();
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );

    _init();
  }

  Future<void> _init() async {
    try {
      _player.playerStateStream.listen((state) {
        if (!mounted) return;

        state.playing ? _iconController.forward() : _iconController.reverse();

        setState(() {
          _isBuffering = state.processingState == ProcessingState.loading ||
              state.processingState == ProcessingState.buffering;
        });
      });

      _player.durationStream.listen((d) {
        if (!mounted) return;
        setState(() => _duration = d ?? Duration.zero);
      });

      await _player.setUrl(widget.audioUrl);
    } catch (e) {
      debugPrint('Audio error: $e');
    }
  }

  @override
  void dispose() {
    _player.dispose();
    _iconController.dispose();
    super.dispose();
  }

  void _toggle() => _player.playing ? _player.pause() : _player.play();

  String _fmt(Duration d) =>
      '${d.inMinutes.remainder(60).toString().padLeft(2, '0')}:${d.inSeconds.remainder(60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          height: 78.h,
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                primaryColor.withOpacity(.85),
                primaryBlack.withOpacity(.9),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(.25),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              _playButton(),
              SizedBox(width: 14.w),
              _sliderSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _playButton() {
    return GestureDetector(
      onTap: _toggle,
      child: Container(
        height: 46.sp,
        width: 46.sp,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [primaryWhite, primaryWhite.withOpacity(.9)],
          ),
        ),
        child: Center(
          child: _isBuffering
              ? SizedBox(
                  height: 18.sp,
                  width: 18.sp,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(primaryColor),
                  ),
                )
              : AnimatedIcon(
                  icon: AnimatedIcons.play_pause,
                  progress: _iconController,
                  size: 26.sp,
                  color: primaryColor,
                ),
        ),
      ),
    );
  }

  Widget _sliderSection() {
    return Expanded(
      child: StreamBuilder<Duration>(
        stream: _player.positionStream,
        builder: (context, snapshot) {
          final position = snapshot.data ?? Duration.zero;

          final double max =
              _duration.inSeconds > 0 ? _duration.inSeconds.toDouble() : 1.0;

          final double value = position.inSeconds.toDouble().clamp(0.0, max);

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 3.h,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.r),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 14.r),
                  activeTrackColor: primaryWhite,
                  inactiveTrackColor: primaryWhite.withOpacity(.25),
                  thumbColor: primaryWhite,
                ),
                child: Slider(
                  min: 0.0,
                  max: max,
                  value: value,
                  onChanged: (v) {
                    _player.seek(Duration(seconds: v.toInt()));
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _fmt(position),
                      style: AppTextStyle.normalRegular10
                          .copyWith(color: lightGreyColor),
                    ),
                    Text(
                      _fmt(_duration),
                      style: AppTextStyle.normalRegular10
                          .copyWith(color: lightGreyColor),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
