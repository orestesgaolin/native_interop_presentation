import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class AnimatedBokehBackground extends StatefulWidget {
  const AnimatedBokehBackground({super.key});

  @override
  State<AnimatedBokehBackground> createState() => _AnimatedBokehBackgroundState();
}

class _AnimatedBokehBackgroundState extends State<AnimatedBokehBackground> with SingleTickerProviderStateMixin {
  late final Ticker controller;
  final ValueNotifier<int> animation = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    controller = createTicker(
      (elapsed) {
        final t = elapsed.inMilliseconds;
        animation.value = t;
      },
    );
    controller.start();
  }

  @override
  void dispose() {
    controller.dispose();
    animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return ShaderBuilder(
          (context, shader, devicePixelRatio) {
            return AnimatedSampler(
              (image, size, canvas) {
                shader.setFloat(0, size.width);
                shader.setFloat(1, size.height);
                shader.setFloat(2, animation.value / 5000);
                // shader.setFloat(3, 0.04);
                canvas.drawRect(
                  Rect.fromLTWH(0, 0, size.width, size.height),
                  Paint()..shader = shader,
                );
              },
              child: SizedBox.expand(),
            );
          },
          assetKey: 'shaders/bokeh_shader.frag',
        );
      },
    );
  }
}
