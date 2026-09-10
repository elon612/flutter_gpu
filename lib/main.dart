import 'package:flutter/material.dart';
import 'package:flutter_scene/scene.dart'
    show
        AmbientOcclusionMethod,
        DepthOfFieldQuality,
        Scene,
        SpecularAmbientOcclusionMode;

import 'example_car.dart';
import 'example_chrome.dart';
import 'example_logo.dart';
import 'example_materialize.dart';
import 'example_settings.dart';

void main() {
  runApp(const ShowcaseApp());
}

/// Per-example overrides of the stock [ExampleSettings] defaults, keyed by
/// the example's name in the picker. Copied from the official
/// `examples/flutter_app` so each scene keeps the look it was tuned for.
final Map<String, ExampleSettings Function()> settingsDefaults = {
  'Materialize (.fmat)': () => ExampleSettings()
    ..directionalLightEnabled = false
    ..colorGrading.enabled = true
    ..colorGrading.brightness = 1.05
    ..colorGrading.contrast = 1.19
    ..colorGrading.saturation = 1.16
    ..colorGrading.temperature = -0.20
    ..colorGrading.tint = 0.01
    ..bloom.enabled = true
    ..bloom.intensity = 0.06
    ..chromaticAberration.enabled = true
    ..chromaticAberration.intensity = 0.14
    ..vignette.enabled = true,
  'Car': () => ExampleSettings()
    ..lightIntensity = 2.043
    ..shadowSoftness = 0.053
    ..contactShadows = true
    ..exposure = 1.954
    ..environmentIntensity = 1.022
    ..ambientOcclusion.enabled = true
    ..ambientOcclusion.method = AmbientOcclusionMethod.groundTruth
    ..ambientOcclusion.visibilityBitmask = true
    ..ambientOcclusion.thickness = 0.338
    ..ambientOcclusion.multiBounce = 0.611
    ..ambientOcclusion.indirectLight = 7.148
    ..ambientOcclusion.specularMode = SpecularAmbientOcclusionMode.simple
    ..colorGrading.enabled = true
    ..colorGrading.brightness = 1.007
    ..colorGrading.contrast = 1.203
    ..colorGrading.saturation = 1.110
    ..colorGrading.temperature = -0.118
    ..colorGrading.tint = -0.161
    ..bloom.enabled = true
    ..bloom.threshold = 0.876
    ..bloom.intensity = 0.191
    ..bloom.lensFlare.enabled = true
    ..bloom.lensFlare.intensity = 0.300
    ..bloom.lensFlare.ghostCount = 5
    ..depthOfField.enabled = true
    ..depthOfField.focusDistance = 7.94
    ..depthOfField.fStop = 0.7
    ..depthOfField.focalLength = 0.077
    ..depthOfField.quality = DepthOfFieldQuality.high
    ..vignette.enabled = true
    ..chromaticAberration.intensity = 0.132
    ..godRays.density = 1.764
    ..godRays.anisotropy = 0.506
    ..autoExposure.strength = 0.663
    ..autoExposure.compensation = 1.265
    ..autoExposure.minEv = -4.455
    ..autoExposure.maxEv = 2.499
    ..autoExposure.speedDown = 0.1,
};

class ShowcaseApp extends StatefulWidget {
  const ShowcaseApp({super.key});

  @override
  State<ShowcaseApp> createState() => _ShowcaseAppState();
}

class _ShowcaseAppState extends State<ShowcaseApp> {
  late final Map<String, WidgetBuilder> examples;
  late String selectedExample;
  late final Future<void> _ready;

  @override
  void initState() {
    super.initState();
    examples = {
      'Materialize (.fmat)': (context) => const ExampleMaterialize(),
      'Car': (context) => const ExampleCar(),
      'Flutter Logo': (context) => const ExampleLogo(),
    };
    selectedExample = examples.keys.first;
    resetExampleSettings(settingsDefaults[selectedExample]);
    _ready = _initialize();
  }

  Future<void> _initialize() async {
    await Scene.initializeStaticResources();
    try {
      await loadExampleEffects();
    } catch (error, stack) {
      debugPrint('Optional example shader bundle skipped: $error\n$stack');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter_scene Showcase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7C4DFF),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        cardTheme: const CardThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
        popupMenuTheme: const PopupMenuThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
      ),
      home: Scaffold(
        backgroundColor: const Color(0xFF06080C),
        body: FutureBuilder<void>(
          future: _ready,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Failed to initialize flutter_scene.\n${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              );
            }
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            return Stack(
              children: [
                SizedBox.expand(child: examples[selectedExample]!(context)),
                ValueListenableBuilder<bool>(
                  valueListenable: exampleChromeVisible,
                  builder: (context, visible, child) =>
                      Offstage(offstage: !visible, child: child),
                  child: SafeArea(
                    minimum: const EdgeInsets.all(8),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: _ExamplePicker(
                        examples: examples.keys.toList(growable: false),
                        selected: selectedExample,
                        onSelected: (next) {
                          setState(() {
                            selectedExample = next;
                            resetExampleSettings(settingsDefaults[next]);
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ExamplePicker extends StatelessWidget {
  const _ExamplePicker({
    required this.examples,
    required this.selected,
    required this.onSelected,
  });

  final List<String> examples;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
      borderRadius: BorderRadius.circular(8),
      elevation: 2,
      child: PopupMenuButton<String>(
        initialValue: selected,
        onSelected: onSelected,
        tooltip: 'Switch example',
        itemBuilder: (context) => [
          for (final name in examples)
            PopupMenuItem<String>(value: name, child: Text(name)),
        ],
        child: SizedBox(
          height: 48,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.view_in_ar, size: 18),
                const SizedBox(width: 8),
                Text(selected),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
