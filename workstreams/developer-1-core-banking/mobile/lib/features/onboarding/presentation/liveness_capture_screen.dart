import 'package:camera/camera.dart';
import 'package:material_ui/material_ui.dart';

import '../../../l10n/app_localizations.dart';

/// S-CB-008 camera capture UI. Capture is intentionally not submitted as a
/// verification result because the API does not define session creation or
/// capture upload.
class LivenessCaptureScreen extends StatefulWidget {
  const LivenessCaptureScreen({super.key});

  @override
  State<LivenessCaptureScreen> createState() => _LivenessCaptureScreenState();
}

class _LivenessCaptureScreenState extends State<LivenessCaptureScreen>
    with WidgetsBindingObserver {
  CameraController? _camera;
  XFile? _capture;
  bool _loading = false;
  bool _recording = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.inactive &&
        state != AppLifecycleState.hidden &&
        state != AppLifecycleState.paused) {
      return;
    }
    final camera = _camera;
    _camera = null;
    _capture = null;
    _recording = false;
    if (mounted) {
      setState(() => _error = 'camera.error.paused');
    }
    camera?.dispose();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _camera?.dispose();
    super.dispose();
  }

  Future<void> _startCamera() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    CameraController? candidate;
    try {
      final devices = await availableCameras();
      if (devices.isEmpty) throw CameraException('no_camera', 'No camera found');
      final selected = devices.where(
        (camera) => camera.lensDirection == CameraLensDirection.front,
      );
      candidate = CameraController(
        selected.isEmpty ? devices.first : selected.first,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await candidate.initialize();
      if (!mounted) {
        await candidate.dispose();
        return;
      }
      await _camera?.dispose();
      setState(() => _camera = candidate);
    } on CameraException catch (error) {
      await candidate?.dispose();
      if (mounted) {
        setState(() {
          _camera = null;
          _error = switch (error.code) {
            'CameraAccessDenied' || 'CameraAccessDeniedWithoutPrompt' =>
              'camera.error.permission',
            _ => 'camera.error.unavailable',
          };
        });
      }
    } catch (_) {
      await candidate?.dispose();
      if (mounted) {
        setState(() {
          _camera = null;
          _error = 'camera.error.unavailable';
        });
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _startRecording() async {
    final camera = _camera;
    if (camera == null || !camera.value.isInitialized || _loading) return;
    try {
      await camera.startVideoRecording();
      if (mounted) setState(() => _recording = true);
    } on CameraException {
      if (mounted) setState(() => _error = 'camera.error.capture');
    }
  }

  Future<void> _stopRecording() async {
    final camera = _camera;
    if (camera == null || !camera.value.isRecordingVideo || _loading) return;
    setState(() => _loading = true);
    try {
      final capture = await camera.stopVideoRecording();
      await camera.dispose();
      if (mounted) {
        setState(() {
          _camera = null;
          _capture = capture;
          _recording = false;
          _error = null;
        });
      }
    } on CameraException {
      if (mounted) setState(() => _error = 'camera.error.capture');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _retake() {
    setState(() {
      _capture = null;
      _error = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    final camera = _camera;
    final errorText = switch (_error) {
      'camera.error.permission' => text.cameraPermissionDenied,
      'camera.error.capture' => text.cameraCaptureError,
      'camera.error.unavailable' => text.cameraUnavailable,
      'camera.error.paused' => text.cameraPaused,
      _ => null,
    };

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: text.commonBack,
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(text.livenessTitle),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  text.onboardingStepSeven,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                text.livenessTitle,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                text.livenessHelper,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 18),
              Expanded(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 0.82,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(140),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHigh,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        child: camera != null && camera.value.isInitialized
                            ? CameraPreview(camera)
                            : Center(
                                child: Icon(
                                  _capture == null
                                      ? Icons.face_retouching_natural
                                      : Icons.video_camera_back_outlined,
                                  size: 96,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: [
                  _GuidanceChip(label: text.livenessGoodLighting),
                  _GuidanceChip(label: text.livenessNoHatOrGlasses),
                  _GuidanceChip(label: text.livenessNeutralExpression),
                ],
              ),
              const SizedBox(height: 10),
              _CapturePromptGuide(
                title: text.livenessPromptHeading,
                blinkPrompt: text.livenessPromptBlink,
                movementPrompt: text.livenessPromptHeadTurn,
              ),
              if (camera != null && _capture == null) ...[
                const SizedBox(height: 12),
                Text(
                  text.livenessPrompts,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              if (errorText != null) ...[
                const SizedBox(height: 12),
                Text(
                  errorText,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
              if (_capture != null) ...[
                const SizedBox(height: 12),
                Text(
                  text.livenessNotVerified,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.icon(
                  onPressed: _loading
                      ? null
                      : _capture != null
                      ? _retake
                      : camera == null
                      ? _startCamera
                      : _recording
                      ? _stopRecording
                      : _startRecording,
                  icon: _loading
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(
                          _capture != null
                              ? Icons.refresh
                              : camera == null
                              ? Icons.camera_alt_outlined
                              : _recording
                              ? Icons.stop_circle_outlined
                              : Icons.fiber_manual_record,
                        ),
                  label: Text(
                    _loading
                        ? text.commonLoading
                        : _capture != null
                        ? text.livenessRetake
                        : camera == null
                        ? text.livenessStartCamera
                        : _recording
                        ? text.livenessStopCapture
                        : text.livenessStartCapture,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                text.livenessContractBlocker,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CapturePromptGuide extends StatelessWidget {
  const _CapturePromptGuide({
    required this.title,
    required this.blinkPrompt,
    required this.movementPrompt,
  });

  final String title;
  final String blinkPrompt;
  final String movementPrompt;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodySmall;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 6),
          _PromptStep(number: '1', label: blinkPrompt, style: style),
          const SizedBox(height: 4),
          _PromptStep(number: '2', label: movementPrompt, style: style),
        ],
      ),
    );
  }
}

class _PromptStep extends StatelessWidget {
  const _PromptStep({required this.number, required this.label, this.style});

  final String number;
  final String label;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      CircleAvatar(
        radius: 10,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: Text(number, style: Theme.of(context).textTheme.labelSmall),
      ),
      const SizedBox(width: 8),
      Expanded(child: Text(label, style: style)),
    ],
  );
}

class _GuidanceChip extends StatelessWidget {
  const _GuidanceChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => Chip(
    avatar: const Icon(Icons.check_circle_outline, size: 16),
    label: Text(label),
    visualDensity: VisualDensity.compact,
  );
}
