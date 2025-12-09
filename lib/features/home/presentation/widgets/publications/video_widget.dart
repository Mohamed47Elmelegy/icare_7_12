// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:icare/core/utils/dark_mode_utility.dart';
// import 'package:icare/features/categories/domain/entities/publications_entity.dart';
// import 'package:icare/features/categories/presentation/bloc/cateogries_bloc.dart';
// import 'package:icare/features/categories/presentation/bloc/cateogries_event.dart';
// import 'package:icare/features/categories/presentation/bloc/cateogries_state.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// class VideoWidget extends StatefulWidget {
//   final PublicationsEntity item;
//   const VideoWidget({super.key, required this.item});

//   @override
//   State<VideoWidget> createState() => _VideoWidgetState();
// }

// class _VideoWidgetState extends State<VideoWidget> {
//   YoutubePlayerController? _controller;
//   Timer? _updateTimer;

//   @override
//   void dispose() {
//     // Cancel any pending timers
//     _updateTimer?.cancel();

//     // Pause the controller to release resources
//     if (_controller != null) {
//       try {
//         if (_controller!.value.isPlaying) {
//           _controller!.pause();
//         }
//       } catch (e) {
//         debugPrint("Error pausing controller on dispose: $e");
//       }
//     }

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       child: BlocBuilder<CategoriesBloc, CategoriesState>(
//         builder: (ctx, state) {
//           var bloc = CategoriesBloc.get(ctx);
//           if (widget.item.videoUrl != "") {
//             int indexV = bloc.videoControllerList.indexWhere((element) =>
//                 element.initialVideoId.toString() ==
//                 YoutubePlayer.convertUrlToId(widget.item.videoUrl));
//             if (indexV == -1) return const SizedBox.shrink();
//             _controller = bloc.videoControllerList[indexV];
//           }
//           if (_controller == null) return const SizedBox.shrink();
//           return SizedBox(
//             height: 250.w,
//             child: Stack(alignment: Alignment.center, children: [
//               YoutubePlayer(
               
//                 controller: _controller!,
//                 showVideoProgressIndicator: true,
//                 onReady: () {
                  
//                   // Do stuff when the player is ready
//                 },
//               ),
//               // Custom play/pause button without fullscreen option
//               // Positioned(
//               //   bottom: 10.w,
//               //   right: 10.w,
//               //   child: InkWell(
//               //     onTap: (){
//               //       _controller!.value.isPlaying
//               //           ? _controller!.pause()
//               //           : _controller!.play();
//               //       _updateTimer?.cancel();
//               //       _updateTimer = Timer(const Duration(seconds: 2), (){
//               //         if (mounted && _controller != null) {
//               //           bloc.add(UpdateVideoControllerEvent(videoPlayerController: _controller!));
//               //         }
//               //       });
//               //     },
//               //     child: CircleAvatar(
//               //       backgroundColor: DMUtil.getWC(),
//               //       radius: 14.w,
//               //       child: Icon(
//               //         _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
//               //         color: DMUtil.getPC(),
//               //         size: 20.w,
//               //       ),
//               //     ),
//               //   ),
//               // ),
//             ]),
//           );
//         },
//       ),
//     );
//   }
// }
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/categories/domain/entities/publications_entity.dart';
import 'package:icare/features/categories/presentation/bloc/cateogries_bloc.dart';
import 'package:icare/features/categories/presentation/bloc/cateogries_event.dart';
import 'package:icare/features/categories/presentation/bloc/cateogries_state.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'full_screen_video_player.dart'; // Import the new widget


class VideoWidget extends StatefulWidget {
  final PublicationsEntity item;
  const VideoWidget({super.key, required this.item});

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  YoutubePlayerController? _controller;
  Timer? _updateTimer;

  @override
  void dispose() {
    _updateTimer?.cancel();
    
    if (_controller != null) {
      try {
        if (_controller!.value.isPlaying) {
          _controller!.pause();
        }
      } catch (e) {
        debugPrint("Error pausing controller on dispose: $e");
      }
    }
    
    super.dispose();
  }

  void _openFullScreenVideo() {
    if (_controller == null) return;
    
    // Pause the current video
    if (_controller!.value.isPlaying) {
      _controller!.pause();
    }
    
    // Navigate to full screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenVideoPlayer(
          controller: _controller!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      child: BlocBuilder<CategoriesBloc, CategoriesState>(
        builder: (ctx, state) {
          var bloc = CategoriesBloc.get(ctx);
          
          if (widget.item.videoUrl != "") {
            int indexV = bloc.videoControllerList.indexWhere(
              (element) => element.initialVideoId.toString() == 
                YoutubePlayer.convertUrlToId(widget.item.videoUrl)
            );
            if (indexV == -1) return const SizedBox.shrink();
            _controller = bloc.videoControllerList[indexV];
          }
          
          if (_controller == null) return const SizedBox.shrink();
          
          return GestureDetector(
            onTap: _openFullScreenVideo,
            child: Container(
              height: 250.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                color: Colors.black,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Video Thumbnail/Player
                    YoutubePlayer(
                      controller: _controller!,
                      showVideoProgressIndicator: false,
                    ),
                    
                    // Play Button Overlay
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Center(
                        child: Container(
                          width: 70.w,
                          height: 70.w,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.play_arrow,
                            color: Colors.red.shade700,
                            size: 40.w,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}