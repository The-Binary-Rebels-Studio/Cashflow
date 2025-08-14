import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:yandex_mobileads/mobile_ads.dart';

@singleton
class AdsService {
  bool _isInitialized = false;

  // Your app ID from AdMob/Yandex
  static const String appId = 'ca-app-pub-6875205837709825~1192450057';

  // Test ad unit IDs - Yandex demo IDs
  static const String _testBannerAdUnitId = 'demo-banner-yandex';

  // Production ad unit IDs - replace with your actual ad unit IDs from Yandex/AdMob
  static const String _prodBannerAdUnitId = 'R-M-16723402-1';

  bool get isInitialized => _isInitialized;

  // Get ad unit IDs based on debug mode
  String get bannerAdUnitId =>
      kDebugMode ? _testBannerAdUnitId : _prodBannerAdUnitId;

  /// Initialize Yandex Mobile Ads SDK
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize Mobile Ads SDK
      MobileAds.initialize();
      _isInitialized = true;

    } catch (e) {
      // Ads initialization failed, will handle gracefully in widget
    }
  }

  /// Get the optimal banner ad size for the given screen width
  BannerAdSize getBannerAdSize(int screenWidth, {int maxHeight = 250}) {
    return BannerAdSize.inline(width: screenWidth, maxHeight: maxHeight);
  }

  // Following Yandex example: widgets create their own BannerAd instances
  // AdsService just provides configuration
}
