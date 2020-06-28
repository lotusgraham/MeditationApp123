import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

import '../enums/fade_animation_enum.dart';

class FadeAnimation extends StatelessWidget {
  final double delay;
  final Widget child;

  FadeAnimation(this.delay, this.child);

  ///build animation track
  @override
  Widget build(BuildContext context) {
    final tween = MultiTween()
      ..add(FadeAnimationEnum.opacity, Tween(begin: 0.0, end: 1.0),
          Duration(milliseconds: 500))
      ..add(FadeAnimationEnum.translateY, Tween(begin: -30.0, end: 0.0),
          Duration(milliseconds: 500), Curves.easeOut);

    /// fade animation controller
    return CustomAnimation(
      delay: Duration(milliseconds: (500 * delay).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builder: (context, child, animation) => Opacity(
        opacity: animation.get(FadeAnimationEnum.opacity),
        child: Transform.translate(
          offset: Offset(
            0,
            animation.get(FadeAnimationEnum.translateY),
          ),
          child: child,
        ),
      ),
    );
  }
}
