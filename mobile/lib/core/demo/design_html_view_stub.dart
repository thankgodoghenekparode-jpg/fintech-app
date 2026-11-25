import 'package:flutter/material.dart';

class DesignHtmlView extends StatelessWidget {
  const DesignHtmlView({required this.html, this.onNavigate, super.key});

  final String html;
  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => const Center(
        child: Text('This design viewer is unavailable on this platform.'),
      );
}
