import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class AnimatedShake extends StatefulWidget {
  const AnimatedShake({super.key, required this.child});

  final Widget child;

  @override
  State<AnimatedShake> createState() => _AnimatedShakeState();
}

class _AnimatedShakeState extends State<AnimatedShake> with SingleTickerProviderStateMixin {
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
                shader.setImageSampler(0, image);
                // shader.setFloat(3, 0.04);
                canvas.drawRect(
                  Rect.fromLTWH(0, 0, size.width, size.height),
                  Paint()..shader = shader,
                );
              },
              child: widget.child,
            );
          },
          assetKey: 'shaders/shake_shader.frag',
        );
      },
    );
  }
}
