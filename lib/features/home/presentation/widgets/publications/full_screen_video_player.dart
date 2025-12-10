import 'package:flutter/material.dart';
import 'package:icare/core/constants/video_player_constants.dart';
import 'package:icare/core/services/video_screen_service.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/home/presentation/widgets/publications/video_player_controls.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class FullScreenVideoPlayer extends StatefulWidget {
  final YoutubePlayerController controller;

  const FullScreenVideoPlayer({
    super.key,
    required this.controller,
  });

  @override
  State<FullScreenVideoPlayer> createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  bool _showControls = true;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    VideoScreenService.enterFullScreen();
    widget.controller.addListener(_onPlayerStateChange);
  }

  void _onPlayerStateChange() {
    if (widget.controller.value.isReady && !_isPlayerReady) {
      setState(() {
        _isPlayerReady = true;
      });

      // Auto-play when ready
      if (mounted && !widget.controller.value.isPlaying) {
        widget.controller.play();
      }

      // Auto-hide controls
      _hideControlsAfterDelay();
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onPlayerStateChange);
    VideoScreenService.exitFullScreen();
    super.dispose();
  }

  void _hideControlsAfterDelay() {
    Future.delayed(VideoPlayerConstants.controlsAutoHideDuration, () {
      if (mounted && widget.controller.value.isPlaying) {
        setState(() => _showControls = false);
      }
    });
  }

  void _toggleControls() {
    setState(() => _showControls = !_showControls);
    if (_showControls) {
      _hideControlsAfterDelay();
    }
  }

  void _togglePlayPause() {
    if (!_isPlayerReady) return;

    setState(() {
      if (widget.controller.value.isPlaying) {
        widget.controller.pause();
        _showControls = true;
      } else {
        widget.controller.play();
        _hideControlsAfterDelay();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _toggleControls,
        child: Stack(
          children: [
            // Video Player - Full Screen
            Center(
              child: AspectRatio(
                aspectRatio: VideoPlayerConstants.reelAspectRatio,
                child: YoutubePlayer(
                  controller: widget.controller,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: DMUtil.getPC(),
                  progressColors: ProgressBarColors(
                    playedColor: DMUtil.getPC(),
                    handleColor: DMUtil.getPC(),
                  ),
                ),
              ),
            ),

            // Controls Overlay
            VideoPlayerControls(
              showControls: _showControls,
              isPlaying: widget.controller.value.isPlaying,
              onPlayPauseTap: _togglePlayPause,
              onCloseTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
