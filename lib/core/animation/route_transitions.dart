import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../util/constants.dart';

class FadeRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  FadeRoute({required this.page})
    : super(
        pageBuilder:
            (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) => page,
        transitionsBuilder:
            (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) => FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(
          milliseconds: AppConstants.animationDuration,
        ),
      );
}

class SlideRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final SlideDirection direction;

  SlideRoute({required this.page, this.direction = SlideDirection.right})
    : super(
        pageBuilder:
            (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) => page,
        transitionsBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
        ) {
          Offset beginOffset;
          switch (direction) {
            case SlideDirection.right:
              beginOffset = const Offset(1.0, 0.0);
              break;
            case SlideDirection.left:
              beginOffset = const Offset(-1.0, 0.0);
              break;
            case SlideDirection.up:
              beginOffset = const Offset(0.0, 1.0);
              break;
            case SlideDirection.down:
              beginOffset = const Offset(0.0, -1.0);
              break;
          }

          return SlideTransition(
            position: Tween<Offset>(
              begin: beginOffset,
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOut),
            ),
            child: child,
          );
        },
        transitionDuration: const Duration(
          milliseconds: AppConstants.animationDuration,
        ),
      );
}

enum SlideDirection { right, left, up, down }

class ScaleRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  ScaleRoute({required this.page})
    : super(
        pageBuilder:
            (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) => page,
        transitionsBuilder:
            (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) => ScaleTransition(
              scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn),
              ),
              child: child,
            ),
        transitionDuration: const Duration(
          milliseconds: AppConstants.animationDuration,
        ),
      );
}

class FadeUpwardsPageTransition extends CustomTransitionPage<void> {
  FadeUpwardsPageTransition({required LocalKey super.key, required super.child})
    : super(
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(
              Tween(
                begin: const Offset(0.0, 0.25),
                end: Offset.zero,
              ).chain(CurveTween(curve: Curves.easeOutCubic)),
            ),
            child: FadeTransition(
              opacity: animation.drive(CurveTween(curve: Curves.easeOutCubic)),
              child: child,
            ),
          );
        },
      );
}
