import 'package:audioplayers/audioplayers.dart';
import 'package:auto_route/auto_route.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:todo_list/gen/assets.gen.dart';
import 'package:video_player/video_player.dart';

import '../../gen/fonts.gen.dart';

// Màn hình demo các loại resource: Font, SVG, Audio, Video.
@RoutePage()
class DemoResourcesPage extends StatefulWidget {
  const DemoResourcesPage({super.key});

  @override
  State<DemoResourcesPage> createState() => _DemoResourcesPageState();
}

class _DemoResourcesPageState extends State<DemoResourcesPage> {
  // --- AUDIO ---
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isAudioPlaying = false;
  Duration _audioPosition = Duration.zero;
  Duration _audioDuration = Duration.zero;
  static const String _audioUrl = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';

  // --- VIDEO ---
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _videoReady = false;
  String? _videoError;
  static const String _videoUrl =
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';

  @override
  void initState() {
    super.initState();
    _initAudio();
    _initVideo();
  }

  void _initAudio() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() => _isAudioPlaying = state == PlayerState.playing);
    });
    _audioPlayer.onDurationChanged.listen((d) {
      if (!mounted) return;
      setState(() => _audioDuration = d);
    });
    _audioPlayer.onPositionChanged.listen((p) {
      if (!mounted) return;
      setState(() => _audioPosition = p);
    });
  }

  Future<void> _initVideo() async {
    try {
      final controller = VideoPlayerController.networkUrl(Uri.parse(_videoUrl));
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      _videoController = controller;
      _chewieController = ChewieController(
        videoPlayerController: controller,
        autoPlay: false,
        looping: false,
        aspectRatio: controller.value.aspectRatio,
      );
      setState(() => _videoReady = true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _videoError = e.toString());
    }
  }

  Future<void> _toggleAudio() async {
    if (_isAudioPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(UrlSource(_audioUrl));
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _chewieController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Demo Resources')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('1. Google Fonts'),
            _fontDemo(),
            const SizedBox(height: 24),
            _sectionTitle('2. SVG (flutter_svg)'),
            _svgDemo(),
            const SizedBox(height: 24),
            _sectionTitle('3. Audio (audioplayers)'),
            _audioDemo(),
            const SizedBox(height: 24),
            _sectionTitle('4. Video (video_player + chewie)'),
            _videoDemo(),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
  );

  Widget _fontDemo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Poppins Regular — Hello Flutter',
          style: TextStyle(
            fontFamily: FontFamily.poppins,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
        const Text(
          'Poppins Medium — Xin chào',
          style: TextStyle(
            fontFamily: FontFamily.poppins,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Text(
          'Poppins SemiBold — Tiêu đề',
          style: TextStyle(
            fontFamily: FontFamily.poppins,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Text(
          'Poppins Bold — Nhấn mạnh',
          style: TextStyle(
            fontFamily: FontFamily.poppins,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _svgDemo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Assets.svg.icDemoStar.svg(width: 56, height: 56),
        Assets.svg.icDemoHeart.svg(width: 56, height: 56),
        Assets.svg.icDemoCheck.svg(width: 56, height: 56),
      ],
    );
  }

  Widget _audioDemo() {
    final total = _audioDuration.inMilliseconds.toDouble();
    final current = _audioPosition.inMilliseconds
        .clamp(0, _audioDuration.inMilliseconds)
        .toDouble();
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                iconSize: 40,
                onPressed: _toggleAudio,
                icon: Icon(
                  _isAudioPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                  color: Colors.deepPurple,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'SoundHelix Sample Song',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '${_formatDuration(_audioPosition)} / ${_formatDuration(_audioDuration)}',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Slider(
            value: current,
            min: 0,
            max: total > 0 ? total : 1,
            onChanged: total > 0
                ? (v) => _audioPlayer.seek(Duration(milliseconds: v.toInt()))
                : null,
          ),
        ],
      ),
    );
  }

  Widget _videoDemo() {
    if (_videoError != null) {
      return Text('Lỗi load video: $_videoError', style: const TextStyle(color: Colors.red));
    }
    if (!_videoReady || _chewieController == null) {
      return const SizedBox(height: 200, child: Center(child: CircularProgressIndicator()));
    }
    return AspectRatio(
      aspectRatio: _videoController!.value.aspectRatio,
      child: Chewie(controller: _chewieController!),
    );
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
