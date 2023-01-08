import 'dart:io';

class AdHelper {
  static String get generalBannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-8256113915144725/6811470331';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-8256113915144725/6811470331';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }

  static String get questionBannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-8256113915144725/2485261216';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-8256113915144725/2485261216';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-8256113915144725/7687332067";
    } else if (Platform.isIOS) {
      return "ca-app-pub-8256113915144725/7687332067";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardedAnswersAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-8256113915144725/2868404590";
    } else if (Platform.isIOS) {
      return "ca-app-pub-8256113915144725/2868404590";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
  static String get rewardedPointsAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-8256113915144725/9433812947";
    } else if (Platform.isIOS) {
      return "ca-app-pub-8256113915144725/9433812947";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}
