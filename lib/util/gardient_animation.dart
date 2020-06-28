import 'package:flutter/material.dart';
import 'package:meditation/util/color.dart';
import 'package:simple_animations/simple_animations.dart';

import '../enums/gradient_animation_enum.dart';

class GradientAnimation extends StatelessWidget {
  const GradientAnimation({Key key, @required this.child}) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final _tween = MultiTween()
      ..add(
        GradientAnimationEnum.left,
        ColorTween(begin: primaryColor, end: Colors.blue),
      )
      ..add(
        GradientAnimationEnum.right,
        ColorTween(begin: Colors.blue, end: primaryColor),
      );

    return CustomAnimation(
      control: CustomAnimationControl.MIRROR,
      duration: const Duration(seconds: 5),
      tween: _tween,
      child: child,
      builder: (context, child, value) {
        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              value.get(GradientAnimationEnum.left),
              value.get(GradientAnimationEnum.right),
            ]),
          ),
          child: child,
        );
      },
    );
  }
}
