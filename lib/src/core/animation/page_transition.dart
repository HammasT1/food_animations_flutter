import 'package:flutter/material.dart';

/// A cinematic "zoom-through" route transition: the new screen blooms up from
/// 92% scale with a fade while the old one eases back, so navigation feels like
/// diving into the next screen rather than a hard cut.
class NoAnimationTransition extends MaterialPageRoute {
  NoAnimationTransition(
      {required WidgetBuilder builder, RouteSettings? routeSettings})
      : super(
            builder: builder,
            settings: routeSettings,
            maintainState: true,
            fullscreenDialog: false);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 520);

  @override
  Duration get reverseTransitionDuration => const Duration(milliseconds: 420);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    final entering = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    final leaving = CurvedAnimation(
      parent: secondaryAnimation,
      curve: Curves.easeInOutCubic,
    );

    return FadeTransition(
      opacity: entering,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.92, end: 1.0).animate(entering),
        child: ScaleTransition(
          // subtle push-back of the outgoing screen
          scale: Tween<double>(begin: 1.0, end: 1.04).animate(leaving),
          child: FadeTransition(
            opacity: Tween<double>(begin: 1.0, end: 0.0).animate(
              CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeIn),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Sheet-style: the new screen slides up over the current one, which dims and
/// eases back a touch.
class SlideUpRoute<T> extends PageRouteBuilder<T> {
  SlideUpRoute({required WidgetBuilder builder, super.settings})
      : super(
          transitionDuration: const Duration(milliseconds: 480),
          reverseTransitionDuration: const Duration(milliseconds: 380),
          pageBuilder: (context, a, b) => builder(context),
          transitionsBuilder: (context, animation, secondary, child) {
            final slide = Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
                reverseCurve: Curves.easeInCubic));
            final dim = Tween<double>(begin: 1, end: 0.9).animate(
                CurvedAnimation(parent: secondary, curve: Curves.easeOut));
            return SlideTransition(
              position: slide,
              child: ScaleTransition(scale: dim, child: child),
            );
          },
        );
}

/// Material shared-axis (X): outgoing slides/fades left, incoming enters from the
/// right — for lateral steps in a flow.
class SharedAxisRoute<T> extends PageRouteBuilder<T> {
  SharedAxisRoute({required WidgetBuilder builder, super.settings})
      : super(
          transitionDuration: const Duration(milliseconds: 440),
          reverseTransitionDuration: const Duration(milliseconds: 380),
          pageBuilder: (context, a, b) => builder(context),
          transitionsBuilder: (context, animation, secondary, child) {
            const dist = 0.28;
            final enter = CurvedAnimation(
                parent: animation, curve: Curves.easeOutCubic);
            final exit = CurvedAnimation(
                parent: secondary, curve: Curves.easeInCubic);
            return SlideTransition(
              position: Tween(begin: const Offset(dist, 0), end: Offset.zero)
                  .animate(enter),
              child: FadeTransition(
                opacity: enter,
                child: SlideTransition(
                  position: Tween(
                          begin: Offset.zero, end: const Offset(-dist, 0))
                      .animate(exit),
                  child: FadeTransition(
                    opacity: Tween<double>(begin: 1, end: 0).animate(exit),
                    child: child,
                  ),
                ),
              ),
            );
          },
        );
}
