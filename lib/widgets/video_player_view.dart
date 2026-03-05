import 'dart:io';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:window_manager/window_manager.dart';

class VideoPlayerView extends StatefulWidget {
  final File file;
  const VideoPlayerView({super.key, required this.file});

  @override
  State<VideoPlayerView> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  late final Player _player;
  late final VideoController _controller;

  @override
  void initState() {
    super.initState();
    _player = Player();
    _controller = VideoController(_player);
    _player.open(Media(widget.file.uri.toString()));
  }

  @override
  void dispose() {
    _player.dispose(); // clears all state on close/switch
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Video(
            controller: _controller, 
            controls: NoVideoControls,
            onEnterFullscreen: () async {
              await WindowManager.instance.setFullScreen(true);
            },
            onExitFullscreen: () async {
              await WindowManager.instance.setFullScreen(false);
            },
          ),
        ),
        _ControlBar(player: _player),
      ],
    );
  }
}

class _ControlBar extends StatefulWidget {
  final Player player;
  const _ControlBar({required this.player});

  @override
  State<_ControlBar> createState() => _ControlBarState();
}

class _ControlBarState extends State<_ControlBar> {
  bool _isFullscreen = false;

  Future<void> _toggleFullscreen() async {
    _isFullscreen = !_isFullscreen;
    await WindowManager.instance.setFullScreen(_isFullscreen);
    setState(() {});
  }
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.player.stream.position,
      builder: (_, posSnap) {
        return StreamBuilder(
          stream: widget.player.stream.duration,
          builder: (_, durSnap) {
            final position = posSnap.data ?? Duration.zero;
            final duration = durSnap.data ?? Duration.zero;

            return Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  // Seek slider
                  Slider(
                    value: position.inSeconds.toDouble().clamp(
                      0,
                      duration.inSeconds.toDouble(),
                    ),
                    max: duration.inSeconds.toDouble().clamp(
                      1,
                      double.infinity,
                    ),
                    onChanged:
                        (v) => widget.player.seek(Duration(seconds: v.toInt())),
                  ),
                  // Position / Duration
                  Text (
                    "${position.toString().split('.').first} / ${duration.toString().split('.').first}",
                    style: const TextStyle(fontSize: 12),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Prev
                      // IconButton(
                      //   icon: const Icon(Icons.skip_previous),
                      //   onPressed: () => widget.player.previous(),
                      // ),
                      // Play/Pause
                      StreamBuilder(
                        stream: widget.player.stream.playing,
                        builder:
                            (_, snap) => IconButton(
                              iconSize: 40,
                              icon: Icon(
                                snap.data == true
                                    ? Icons.pause_circle
                                    : Icons.play_circle,
                              ),
                              onPressed: () => widget.player.playOrPause(),
                            ),
                      ),
                      // Next
                      // IconButton(
                      //   icon: const Icon(Icons.skip_next),
                      //   onPressed: () => widget.player.next(),
                      // ),
                      const SizedBox(width: 16),
                      // Volume
                      const Icon(Icons.volume_up, size: 20),
                      SizedBox(
                        width: 100,
                        child: StreamBuilder(
                          stream: widget.player.stream.volume,
                          builder:
                              (_, snap) => Slider(
                                value: (snap.data ?? 100.0) / 100,
                                onChanged:
                                    (v) => widget.player.setVolume(v * 100),
                              ),
                        ),
                      ),
                      StreamBuilder<bool>(
                        stream: widget.player.stream.playing.map(
                          (_) => _isFullscreen,
                        ),
                        builder:
                            (_, __) => IconButton(
                              icon: Icon(
                                _isFullscreen
                                    ? Icons.fullscreen_exit
                                    : Icons.fullscreen,
                              ),
                              onPressed: _toggleFullscreen,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
