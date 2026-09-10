# flutter_scene Web Showcase

用 [flutter_scene](https://pub.dev/packages/flutter_scene) 官方示例里最炫的几个场景，做成可在浏览器里跑的 Web 展示。

默认打开的是官网首页同款 **Materialize**：Khronos `DamagedHelmet` 从线框 → 玻璃碎片飞入 → PBR 实体，分三层扫过模型。

另外两个可选场景：

- **Car**：巴黎环境光下的展厅跑车，可开车门 / 转向
- **Flutter Logo**：烘焙过的 Flutter Logo，相机绕行

示例逻辑来自官方仓库 [`bdero/flutter_scene`](https://github.com/bdero/flutter_scene) 的 `examples/flutter_app`。

## 运行（Web）

需要 **Flutter 3.47+**（当前 stable 即可）。

```sh
flutter pub get
flutter config --enable-native-assets
flutter config --enable-dart-data-assets
flutter run -d chrome
```

构建静态站点：

```sh
flutter build web --release
# 产物在 build/web/
python3 -m http.server 8080 --directory build/web
```

原生平台同样可以跑，记得加上 `--enable-flutter-gpu`。
