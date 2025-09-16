import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:mesh/mesh.dart';

class AnimatedMeshGradientBackground extends StatefulWidget {
  const AnimatedMeshGradientBackground({super.key});

  @override
  State<AnimatedMeshGradientBackground> createState() => _AnimatedMeshGradientBackgroundState();
}

class _AnimatedMeshGradientBackgroundState extends State<AnimatedMeshGradientBackground> with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this)
      ..duration = const Duration(seconds: 20)
      ..forward()
      ..addListener(() {
        if (controller.value == 1.0) {
          controller.animateTo(0, curve: Curves.easeInOutQuint);
        }
        if (controller.value == 0.0) {
          controller.animateTo(1, curve: Curves.easeInOutCubic);
        }
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NoiseShader(
      child: SizedBox.expand(
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            final dt = controller.value;
            final xPos = 0.2 + (0.4 * dt);
            return OMeshGradient(
              tessellation: 12,
              size: Size.infinite,
              mesh: OMeshRect(
                height: 3,
                width: 3,
                fallbackColor: Color(0xff070709),
                backgroundColor: Color(0xff070709),
                vertices: [
                  (-0.00, -0.00).v, (xPos, -0.0).v, (1.0, 0.0).v, // Row 1
                  (0.0, 0.5).v, (0.23, 0.25).v, (1.0, 0.5).v, // Row 2
                  (0.0, 1.0).v, (1 - xPos, 1.0).v, (1.0, 1.0).v, // Row 3
                ],
                colors: const [
                  Color(0xfff7f0ff),
                  Color(0xffffffff),
                  Color(0xff95bcf0), // Row 1
                  Color(0xff1519a8),
                  Color.fromARGB(255, 234, 236, 255),
                  Color(0xff324073), // Row 2
                  Color(0xff5087ba),
                  Color(0xff1553a8),
                  Color(0xffffe9f4), // Row 3
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

extension on OVertex {
  OVertex to(OVertex b, double t) => lerpTo(b, t);
}

extension on Color? {
  Color? to(Color? b, double t) => Color.lerp(this, b, t);
}

typedef C = Colors;

class NoiseShader extends StatelessWidget {
  const NoiseShader({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderBuilder(
      (context, shader, devicePixelRatio) {
        return AnimatedSampler(
          (image, size, canvas) {
            shader.setImageSampler(0, image);
            shader.setFloat(0, size.width);
            shader.setFloat(1, size.height);
            shader.setFloat(2, 0.2);
            canvas.drawRect(
              Rect.fromLTWH(0, 0, size.width, size.height),
              Paint()..shader = shader,
            );
          },
          child: child,
        );
      },
      assetKey: 'shaders/noise_shader.frag',
    );
  }
}
