import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icare/core/constants/video_player_constants.dart';

import '../../../../../core/utils/dark_mode_utility.dart';

class VideoPlayerControls extends StatelessWidget {
  final bool showControls;
  final bool isPlaying;
  final VoidCallback onPlayPauseTap;
  final VoidCallback onCloseTap;

  const VideoPlayerControls({
    super.key,
    required this.showControls,
    required this.isPlaying,
    required this.onPlayPauseTap,
    required this.onCloseTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Top Gradient
        if (showControls) _buildTopGradient(),

        // Close Button
        if (showControls) _buildCloseButton(),

        // Play/Pause Button
        if (showControls || !isPlaying) _buildPlayPauseButton(),

        // Bottom Gradient
        if (showControls) _buildBottomGradient(),
      ],
    );
  }

  Widget _buildTopGradient() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: VideoPlayerConstants.overlayHeight.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(VideoPlayerConstants.overlayOpacity),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCloseButton() {
    return Positioned(
      top: 40.h,
      left: 16.w,
      child: SafeArea(
        child: IconButton(
          icon: Icon(
            Icons.close,
            color: DMUtil.getWC(),
            size: VideoPlayerConstants.closeIconSize.sp,
          ),
          onPressed: onCloseTap,
        ),
      ),
    );
  }

  Widget _buildPlayPauseButton() {
    return Center(
      child: AnimatedOpacity(
        opacity: showControls || !isPlaying ? 1.0 : 0.0,
        duration: VideoPlayerConstants.fadeAnimationDuration,
        child: GestureDetector(
          onTap: onPlayPauseTap,
          child: Container(
            width: VideoPlayerConstants.playButtonSize.w,
            height: VideoPlayerConstants.playButtonSize.w,
            decoration: BoxDecoration(
              color: Colors.white
                  .withOpacity(VideoPlayerConstants.playButtonOpacity),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black
                      .withOpacity(VideoPlayerConstants.shadowOpacity),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.red.shade700,
              size: VideoPlayerConstants.playIconSize.w,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomGradient() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: VideoPlayerConstants.overlayHeight.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(VideoPlayerConstants.overlayOpacity),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}
