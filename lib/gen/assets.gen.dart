/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsBackgroundsGen {
  const $AssetsBackgroundsGen();

  /// File path: assets/backgrounds/avenue-815297_640.jpg
  AssetGenImage get avenue815297640 =>
      const AssetGenImage('assets/backgrounds/avenue-815297_640.jpg');

  /// File path: assets/backgrounds/collect_info_background.jpg
  AssetGenImage get collectInfoBackground =>
      const AssetGenImage('assets/backgrounds/collect_info_background.jpg');

  /// File path: assets/backgrounds/other_option.jpeg
  AssetGenImage get otherOption =>
      const AssetGenImage('assets/backgrounds/other_option.jpeg');

  /// File path: assets/backgrounds/register_background.jpg
  AssetGenImage get registerBackground =>
      const AssetGenImage('assets/backgrounds/register_background.jpg');

  /// List of all assets
  List<AssetGenImage> get values =>
      [avenue815297640, collectInfoBackground, otherOption, registerBackground];
}

class $AssetsGifsGen {
  const $AssetsGifsGen();

  /// File path: assets/gifs/hello.gif
  AssetGenImage get hello => const AssetGenImage('assets/gifs/hello.gif');

  /// List of all assets
  List<AssetGenImage> get values => [hello];
}

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/danger.svg
  String get danger => 'assets/icons/danger.svg';

  /// File path: assets/icons/home.svg
  String get home => 'assets/icons/home.svg';

  /// File path: assets/icons/pencil.svg
  String get pencil => 'assets/icons/pencil.svg';

  /// File path: assets/icons/runner.svg
  String get runner => 'assets/icons/runner.svg';

  /// File path: assets/icons/settings.svg
  String get settings => 'assets/icons/settings.svg';

  /// List of all assets
  List<String> get values => [danger, home, pencil, runner, settings];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/ceahlau.jpg
  AssetGenImage get ceahlau => const AssetGenImage('assets/images/ceahlau.jpg');

  /// List of all assets
  List<AssetGenImage> get values => [ceahlau];
}

class Assets {
  Assets._();

  static const $AssetsBackgroundsGen backgrounds = $AssetsBackgroundsGen();
  static const $AssetsGifsGen gifs = $AssetsGifsGen();
  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
