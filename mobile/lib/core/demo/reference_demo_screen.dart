import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'design_html_view.dart';

class ReferenceDemoScreen extends StatefulWidget {
  const ReferenceDemoScreen({
    required this.screenId,
    required this.sourceRoute,
    super.key,
  });

  final String screenId;
  final String sourceRoute;

  @override
  State<ReferenceDemoScreen> createState() => _ReferenceDemoScreenState();
}

class _ReferenceDemoScreenState extends State<ReferenceDemoScreen> {
  late final Future<String> _html = _loadDemoHtml();

  Future<String> _loadDemoHtml() async {
    final suppliedHtml = await rootBundle.loadString(
      'assets/design_html/${widget.screenId}.html',
    );
    // A supplied screen used a fixed 390px viewport and disabled zoom. Use the
    // actual preview viewport for every mobile design so narrow devices fit.
    final source = suppliedHtml.replaceAll(
      RegExp(
        r'<meta\s+content="[^"]*"\s+name="viewport"\s*/?>',
        caseSensitive: false,
      ),
      '<meta name="viewport" content="width=device-width, initial-scale=1.0" />',
    );
    final actions = await rootBundle.loadString('assets/demo_actions.js');
    final runtime =
        '<script>window.__designDemoScreenId=${_jsString(widget.screenId)};</script><script>$actions</script>';
    const responsiveStyles = '''
<style>
  html, body { width: 100%; max-width: 100%; min-width: 0; overflow-x: hidden; }
  img, video, canvas, svg { max-width: 100%; }
  input, select, textarea, button { max-width: 100%; }
  @media (max-width: 390px) {
    [class~="w-[390px]"], [class~="w-[420px]"], [class~="w-[430px]"] {
      width: 100% !important;
    }
  }
</style>
''';
    final responsiveHtml = source.replaceFirst(
      RegExp('</head>', caseSensitive: false),
      '$responsiveStyles</head>',
    );
    final bodyEnd = responsiveHtml.toLowerCase().lastIndexOf('</body>');
    return bodyEnd < 0
        ? '$responsiveHtml$runtime'
        : '${responsiveHtml.substring(0, bodyEnd)}$runtime${responsiveHtml.substring(bodyEnd)}';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text('${widget.screenId} - Design screen')),
      body: Column(
        children: [
          ColoredBox(
            color: colorScheme.secondaryContainer,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.visibility_outlined,
                      color: colorScheme.onSecondaryContainer),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Design sample - read-only demo; no live account data or transactions.',
                      style: TextStyle(color: colorScheme.onSecondaryContainer),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<String>(
              future: _html,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'Could not load the supplied design for ${widget.screenId}.\n${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                return DesignHtmlView(
                  key: ValueKey(widget.screenId),
                  html: snapshot.data!,
                  onNavigate: _handleDemoNavigation,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _handleDemoNavigation(String destination) {
    if (destination == 'back') {
      if (context.canPop()) {
        context.pop();
      } else {
        context.go('/design-previews');
      }
      return;
    }
    const sectionRoutes = <String, String>{
      'home': '/design-preview/S-AGT-001?from=bottom-navigation',
      'payments': '/design-preview/S-REV-001?from=bottom-navigation',
      'save-borrow': '/design-preview/S-TGT-001?from=bottom-navigation',
      'more': '/more',
      'paid-history': '/design-preview/S-REV-004?from=paid-history',
      'cancel-float-top-up':
          '/design-preview/S-AGT-001?from=cancel-float-top-up',
    };
    if (destination.startsWith('/')) {
      context.push(destination);
      return;
    }
    final route = sectionRoutes[destination];
    if (route != null) {
      if (const {
        'more',
        'paid-history',
        'cancel-float-top-up',
      }.contains(destination)) {
        context.push(route);
      } else {
        context.go(route);
      }
    } else if (destination == 'cards') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('No Cards design was supplied for this demo.')),
      );
    }
  }
}

String _jsString(String value) =>
    '"${value.replaceAll(r'\\', r'\\\\').replaceAll('"', r'\"')}"';
