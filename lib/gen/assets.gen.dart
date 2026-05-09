// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/bomb.gif
  AssetGenImage get bomb => const AssetGenImage('assets/images/bomb.gif');

  /// File path: assets/images/bomb_target.png
  AssetGenImage get bombTarget =>
      const AssetGenImage('assets/images/bomb_target.png');

  /// File path: assets/images/clock_icon.png
  AssetGenImage get clockIcon =>
      const AssetGenImage('assets/images/clock_icon.png');

  /// File path: assets/images/dead_icon.png
  AssetGenImage get deadIcon =>
      const AssetGenImage('assets/images/dead_icon.png');

  /// File path: assets/images/disconnected.png
  AssetGenImage get disconnected =>
      const AssetGenImage('assets/images/disconnected.png');

  /// File path: assets/images/explosion.gif
  AssetGenImage get explosion =>
      const AssetGenImage('assets/images/explosion.gif');

  /// File path: assets/images/fire.gif
  AssetGenImage get fire => const AssetGenImage('assets/images/fire.gif');

  /// File path: assets/images/fire_sprite.png
  AssetGenImage get fireSprite =>
      const AssetGenImage('assets/images/fire_sprite.png');

  /// File path: assets/images/not_ready_icon.png
  AssetGenImage get notReadyIcon =>
      const AssetGenImage('assets/images/not_ready_icon.png');

  /// File path: assets/images/ready_icon.png
  AssetGenImage get readyIcon =>
      const AssetGenImage('assets/images/ready_icon.png');

  /// File path: assets/images/robot_blue.png
  AssetGenImage get robotBlue =>
      const AssetGenImage('assets/images/robot_blue.png');

  /// File path: assets/images/robot_red.png
  AssetGenImage get robotRed =>
      const AssetGenImage('assets/images/robot_red.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    bomb,
    bombTarget,
    clockIcon,
    deadIcon,
    disconnected,
    explosion,
    fire,
    fireSprite,
    notReadyIcon,
    readyIcon,
    robotBlue,
    robotRed,
  ];
}

class Assets {
  const Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

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
    FilterQuality filterQuality = FilterQuality.medium,
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

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}
