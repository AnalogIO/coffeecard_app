import 'package:flutter/material.dart';

class FastSlideTransition extends PageRouteBuilder {
  final Widget child;
  final Duration duration;
  final Curve slideCurve;
  final Curve fadeCurve;

  FastSlideTransition({
    required this.child,
    this.duration = const Duration(milliseconds: 650),
    this.slideCurve = Curves.fastLinearToSlowEaseIn,
    this.fadeCurve = Curves.easeOutCubic,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: duration,
          reverseTransitionDuration: duration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: Tween<double>(begin: 0, end: 1).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: fadeCurve,
                  reverseCurve: fadeCurve.flipped,
                ),
              ),
              child: FadeTransition(
                opacity: Tween<double>(begin: 1, end: 0).animate(
                  CurvedAnimation(
                    parent: secondaryAnimation,
                    curve: fadeCurve,
                    reverseCurve: slideCurve.flipped,
                  ),
                ),
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: slideCurve,
                      reverseCurve: slideCurve.flipped,
                    ),
                  ),
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset.zero,
                      end: const Offset(-1, 0),
                    ).animate(
                      CurvedAnimation(
                        parent: secondaryAnimation,
                        curve: slideCurve,
                        reverseCurve: slideCurve.flipped,
                      ),
                    ),
                    child: child,
                  ),
                ),
              ),
            );
          },
        );
}
