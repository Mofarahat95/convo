import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdManager {
  static void showInterstitialAdBeforeAction({
    required VoidCallback onContinue,
  }) {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-6706273048076252/4938260586', // ← غيّره لو عندك ID تاني
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              onContinue();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              onContinue();
            },
          );
          ad.show();
        },
        onAdFailedToLoad: (error) {
          debugPrint('InterstitialAd failed to load: $error');
          onContinue(); // كمل عادي لو فشل
        },
      ),
    );
  }
}
