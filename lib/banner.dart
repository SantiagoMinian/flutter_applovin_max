import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_applovin_max/flutter_applovin_max.dart';

enum BannerAdSize {
  banner,
  mrec,
  leader,
}

class BannerPx {
  final double width;
  final double height;
  BannerPx(this.width, this.height);
}

class BannerMaxView extends StatelessWidget {
  final AppLovinListener listener;
  final Map<BannerAdSize, String> sizes = {
    BannerAdSize.banner: 'BANNER',
    BannerAdSize.leader: 'LEADER',
    BannerAdSize.mrec: 'MREC'
  };
  final Map<BannerAdSize, BannerPx> sizesNum = {
    BannerAdSize.banner: BannerPx(350, 50),
    BannerAdSize.leader: BannerPx(double.infinity, 90),
    BannerAdSize.mrec: BannerPx(300, 250)
  };
  final BannerAdSize size;
  final String adUnitId;

  BannerMaxView(this.listener, this.size, this.adUnitId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final void Function(int) onPlatformViewCreated = (int i) {
      const MethodChannel channel = MethodChannel('AppLovin');
      channel.setMethodCallHandler((MethodCall call) async => FlutterApplovinMax.handleMethod(call, listener));
    };

    final Widget platformView = Platform.isAndroid
        ? AndroidView(
            viewType: '/Banner',
            key: UniqueKey(),
            creationParams: {'Size': sizes[size], 'UnitId': adUnitId},
            creationParamsCodec: const StandardMessageCodec(),
            onPlatformViewCreated: onPlatformViewCreated,
          )
        : UiKitView(
            viewType: 'flutter_applovin_max_banner',
            layoutDirection: TextDirection.ltr,
            creationParams: <String, dynamic>{'UnitId': adUnitId},
            creationParamsCodec: const StandardMessageCodec(),
            onPlatformViewCreated: onPlatformViewCreated,
          );

    return Container(
      width: sizesNum[size]?.width,
      height: sizesNum[size]?.height,
      child: platformView,
    );
  }
}
