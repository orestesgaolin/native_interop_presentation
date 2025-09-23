import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:video_player/video_player.dart';

class BlockThreadContent extends StatefulWidget {
  const BlockThreadContent({super.key});

  @override
  State<BlockThreadContent> createState() => _BlockThreadContentState();
}

class _BlockThreadContentState extends State<BlockThreadContent> {
  late VideoPlayerController _controller1;
  late VideoPlayerController _controller2;

  @override
  void initState() {
    super.initState();
    _controller1 = VideoPlayerController.asset('assets/thread-3.19.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller1.play();
        _controller1.setLooping(true);
      });
    _controller2 = VideoPlayerController.asset('assets/thread-3.35.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller2.play();
        _controller2.setLooping(true);
      });
  }

  Future<void> blockMainThread() async {
    // Simulate blocking the main thread by calling a native method
    // that sleeps for 10 seconds.
    const platform = MethodChannel('com.example/benchmark');
    try {
      final String result = await platform.invokeMethod('blockMainThread');
      print(result);
    } on PlatformException catch (e) {
      print("Failed to block main thread: '${e.message}'.");
    }
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final header = FlutterDeckTheme.of(context).textTheme.header;
    final bigBody = FlutterDeckTheme.of(context).textTheme.bodyLarge;
    return Center(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  [
              Text('Flutter 3.19', style: header),
              SizedBox(width: 32),
              Text('Flutter 3.35', style: header),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_controller1.value.isInitialized) ...[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 390,
                    height: 300,
                    // height: 896 / 2,
                    child: VideoPlayer(_controller1),
                  ),
                ),
              ],
              if (_controller2.value.isInitialized) ...[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 390,
                    height: 300,
                    // height: 678 / 2,
                    child: VideoPlayer(_controller2),
                  ),
                ),
              ],
            ],
          ),
          Text(
            'Make sure your code respects the threading principles',
            style: bigBody,
          ),
          CircularProgressIndicator(),
          ElevatedButton(
            onPressed: blockMainThread,
            child: const Text('Block Main Thread for 10 seconds'),
          ),
        ],
      ),
    );
  }
}
