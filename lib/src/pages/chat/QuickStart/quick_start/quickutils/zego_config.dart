import 'package:flutter/foundation.dart';
import 'package:zego_express_engine/zego_express_engine.dart' show ZegoScenario;

class ZegoConfig {
  static final ZegoConfig instance = ZegoConfig._internal();
  ZegoConfig._internal();

  // Here we use the high quality video call scenario as an example,
  // you should choose the appropriate scenario according to your actual situation,
  // for the differences between scenarios and how to choose a suitable scenario,
  // please refer to https://docs.zegocloud.com/article/14940
  ZegoScenario scenario = ZegoScenario.HighQualityVideoCall;

  bool enablePlatformView = kIsWeb ? true : false;
}
