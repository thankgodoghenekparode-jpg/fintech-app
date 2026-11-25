import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DesignHtmlView extends StatefulWidget {
  const DesignHtmlView({required this.html, this.onNavigate, super.key});

  final String html;
  final ValueChanged<String>? onNavigate;

  @override
  State<DesignHtmlView> createState() => _DesignHtmlViewState();
}

class _DesignHtmlViewState extends State<DesignHtmlView> {
  late final WebViewController _controller = WebViewController();

  @override
  void initState() {
    super.initState();
    _configureController();
  }

  Future<void> _configureController() async {
    await _controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    await _controller.addJavaScriptChannel(
      'DesignDemoNavigation',
      onMessageReceived: (message) => widget.onNavigate?.call(message.message),
    );
    await _controller.setNavigationDelegate(
      NavigationDelegate(
        onNavigationRequest: (_) => NavigationDecision.prevent,
      ),
    );
    await _controller.loadHtmlString(
      widget.html,
      baseUrl: 'https://design-preview.local/',
    );
  }

  @override
  Widget build(BuildContext context) => WebViewWidget(controller: _controller);
}
