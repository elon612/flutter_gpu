import 'package:flutter_scene/build_hooks.dart';
import 'package:hooks/hooks.dart';

void main(List<String> args) async {
  await build(args, (input, output) async {
    // flutter_scene:init:start
    // Official example models live next to the package as assets_src/,
    // matching the flutter_scene examples/flutter_app layout so loadScene
    // can keep the same source paths.
    const corpus = [
      'assets_src/flutter_logo_baked.glb',
      'assets_src/fcar.glb',
    ];
    buildScenes(
      buildInput: input,
      buildOutput: output,
      inputFilePaths: corpus,
      compressTextures: true,
    );
    buildTextures(
      buildInput: input,
      buildOutput: output,
      textures: ['assets/ground_grid.png'],
    );
    await buildMaterials(buildInput: input, buildOutput: output);
    // flutter_scene:init:end
  });
}
