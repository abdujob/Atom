import 'dart:async';
import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../screens/welcome_screen.dart';

/// Widget qui enveloppe l'application et détecte l'inactivité.
/// Après [timeoutSeconds] secondes sans interaction, redirige vers WelcomeScreen.
class InactivityDetector extends StatefulWidget {
  final Widget child;
  final int timeoutSeconds;

  const InactivityDetector({
    super.key,
    required this.child,
    this.timeoutSeconds = AppConstants.inactivityTimeoutSeconds,
  });

  @override
  State<InactivityDetector> createState() => _InactivityDetectorState();
}

class _InactivityDetectorState extends State<InactivityDetector> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _resetTimer();
  }

  void _resetTimer() {
    _timer?.cancel();
    _timer = Timer(Duration(seconds: widget.timeoutSeconds), _onInactive);
  }

  void _onInactive() {
    if (mounted) {
      // Retourner à l'écran d'accueil
      Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const WelcomeScreen(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 800),
        ),
        (route) => false,
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => _resetTimer(),
      onPointerMove: (_) => _resetTimer(),
      onPointerUp: (_) => _resetTimer(),
      child: widget.child,
    );
  }
}
