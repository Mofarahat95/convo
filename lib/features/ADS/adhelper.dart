import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-6706273048076252/1573849095"; // <-- Ad Unit ID الصحيح للبانر
    } else if (Platform.isIOS) {
      return "ca-app-pub-6706273048076252/ios-banner-id"; // عدله لو عندك
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-6706273048076252/4938260586"; // <-- Ad Unit ID الصحيح للإنتيرستيشال
    } else if (Platform.isIOS) {
      return "ca-app-pub-6706273048076252/ios-interstitial-id"; // عدله لو عندك
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-6706273048076252/ANDROID_REWARDED_ID"; // ← لو هتستخدمها
    } else if (Platform.isIOS) {
      return "ca-app-pub-6706273048076252/IOS_REWARDED_ID";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get nativeAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-6706273048076252/ANDROID_NATIVE_ID"; // ← لو هتستخدم Native
    } else if (Platform.isIOS) {
      return "ca-app-pub-6706273048076252/IOS_NATIVE_ID";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }
}
