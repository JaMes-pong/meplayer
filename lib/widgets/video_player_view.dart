import 'dart:io';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:media_kit_video/media_kit_video_controls/src/controls/extensions/duration.dart';
import 'package:meplayer/utils/app_settings.dart';
import 'package:window_manager/window_manager.dart';

class VideoPlayerView extends StatefulWidget {
  final File file;
  final VoidCallback? onNext;
  final VoidCallback? onPrev;
  const VideoPlayerView({
    super.key,
    required this.file,
    this.onNext,
    this.onPrev,
  });

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
    _player.setVolume(AppSettings().defaultVolume);
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
        _ControlBar(
          player: _player,
          onNext: widget.onNext,
          onPrev: widget.onPrev,
        ),
      ],
    );
  }
}

class _ControlBar extends StatefulWidget {
  final Player player;
  final VoidCallback? onNext;
  final VoidCallback? onPrev;
  const _ControlBar({required this.player, this.onNext, this.onPrev});

  @override
  State<_ControlBar> createState() => _ControlBarState();
}

class _ControlBarState extends State<_ControlBar> {
  bool _isFullscreen = false;
  double _playbackSpeed = 1.0;

  void _seekBy(int seconds) async {
    PlayerState playerState = widget.player.state;

    final current = playerState.position;
    final duration = playerState.duration;
    final target = current + Duration(seconds: seconds);

    await widget.player.seek(target.clamp(Duration.zero, duration));
  }

  void _cycleSpeed() {
    const speeds = [0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0];
    final nextIdx = (speeds.indexOf(_playbackSpeed) + 1) % speeds.length;

    setState(() {
      _playbackSpeed = speeds[nextIdx];
    });

    widget.player.setRate(_playbackSpeed);
  }

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

            // Format duration as mm:ss
            String fmt(Duration d) =>
                '${d.inMinutes.remainder(60).toString().padLeft(2, '0')}:'
                '${d.inSeconds.remainder(60).toString().padLeft(2, '0')}';

            return Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  // Seek slider + timestamps
                  Row(
                    children: [
                      Text(fmt(position), style: const TextStyle(fontSize: 12)),
                      Expanded(
                        child: Slider(
                          value: position.inSeconds.toDouble().clamp(
                            0,
                            duration.inSeconds.toDouble(),
                          ),
                          max: duration.inSeconds.toDouble().clamp(
                            1,
                            double.infinity,
                          ),
                          onChanged:
                              (v) => widget.player.seek(
                                Duration(seconds: v.toInt()),
                              ),
                        ),
                      ),
                      Text(fmt(duration), style: const TextStyle(fontSize: 12)),
                    ],
                  ),

                  // Controls row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Prev file
                      IconButton(
                        icon: const Icon(Icons.skip_previous),
                        tooltip: 'Previous file',
                        onPressed: widget.onPrev,
                      ),

                      // Backward 10s
                      IconButton(
                        icon: const Icon(Icons.replay_10),
                        tooltip: 'Back 10 seconds',
                        onPressed: () => _seekBy(-10),
                      ),

                      // Play / Pause
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

                      // Forward 10s
                      IconButton(
                        icon: const Icon(Icons.forward_10),
                        tooltip: 'Forward 10 seconds',
                        onPressed: () => _seekBy(10),
                      ),

                      // Next file
                      IconButton(
                        icon: const Icon(Icons.skip_next),
                        tooltip: 'Next file',
                        onPressed: widget.onNext,
                      ),

                      const SizedBox(width: 16),

                      // Volume
                      const Icon(Icons.volume_up, size: 20),
                      SizedBox(
                        width: 100,
                        child: StreamBuilder(
                          stream: widget.player.stream.volume,
                          builder:
                              (_, snap) => Slider(
                                value:
                                    (snap.data ?? AppSettings().defaultVolume) /
                                    100,
                                onChanged: (v) {
                                  widget.player.setVolume(v * 100);
                                  AppSettings().defaultVolume = v * 100;
                                },
                              ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Playback speed
                      TextButton(
                        onPressed: _cycleSpeed,
                        child: Text(
                          '${_playbackSpeed}x',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),

                      // Fullscreen
                      IconButton(
                        icon: Icon(
                          _isFullscreen
                              ? Icons.fullscreen_exit
                              : Icons.fullscreen,
                        ),
                        onPressed: _toggleFullscreen,
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
