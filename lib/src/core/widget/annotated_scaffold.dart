// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dribbble_challenge/src/core/widget/ambient_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnnotatedScaffold extends StatelessWidget {
  final Widget child;

  /// Paints drifting coloured light behind the screen for the glass surfaces.
  final bool ambient;

  /// Tints the lead ambient light (e.g. with the current dish's colour).
  final Color? accent;
  const AnnotatedScaffold({
    super.key,
    required this.child,
    this.ambient = true,
    this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (ambient)
              accent == null
                  ? const AmbientBackground()
                  : AmbientBackground(accent: accent!),
            SafeArea(child: child),
          ],
        ),
      ),
    );
  }
}
