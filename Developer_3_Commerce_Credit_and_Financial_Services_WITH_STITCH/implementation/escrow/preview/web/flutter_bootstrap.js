{{flutter_js}}
{{flutter_build_config}}

// Keep the isolated preview self-contained when run without external network
// access. Flutter bundles this CanvasKit build into build/web/canvaskit.
_flutter.loader.load({
  config: {
    canvasKitBaseUrl: 'canvaskit/',
  },
});
