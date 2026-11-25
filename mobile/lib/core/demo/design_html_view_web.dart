// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:async';
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:flutter/widgets.dart';

int _nextViewId = 0;

class DesignHtmlView extends StatefulWidget {
  const DesignHtmlView({required this.html, this.onNavigate, super.key});

  final String html;
  final ValueChanged<String>? onNavigate;

  @override
  State<DesignHtmlView> createState() => _DesignHtmlViewState();
}

class _DesignHtmlViewState extends State<DesignHtmlView> {
  late final String _viewType = 'supplied-design-${_nextViewId++}';
  StreamSubscription<html.MessageEvent>? _messageSubscription;

  @override
  void initState() {
    super.initState();
    _messageSubscription = html.window.onMessage.listen((event) {
      final message = event.data;
      const prefix = 'design-demo-navigation:';
      if (message is String && message.startsWith(prefix)) {
        widget.onNavigate?.call(message.substring(prefix.length));
      }
    });
    ui_web.platformViewRegistry.registerViewFactory(_viewType, (_) {
      final frame = html.IFrameElement()
        ..setAttribute('srcdoc', widget.html)
        ..setAttribute('sandbox', 'allow-scripts allow-forms')
        ..style.border = '0'
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.pointerEvents = 'auto'
        ..style.touchAction = 'manipulation';
      return frame;
    });
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => HtmlElementView(viewType: _viewType);
}
