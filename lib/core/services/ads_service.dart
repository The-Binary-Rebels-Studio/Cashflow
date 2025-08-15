import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:yandex_mobileads/mobile_ads.dart';

@singleton
class AdsService {
  bool _isInitialized = false;

  
  static const String _testBannerAdUnitId = 'demo-banner-admob';
  static const String _testAppOpenAdUnitId = 'demo-appopenad-yandex';

  
  static const String _prodBannerAdUnitId = 'R-M-16723402-1';
  static const String _prodAppOpenAdUnitId = 'R-M-16723402-3';

  bool get isInitialized => _isInitialized;

  
  String get bannerAdUnitId =>
      kDebugMode ? _testBannerAdUnitId : _prodBannerAdUnitId;

  String get appOpenAdUnitId =>
      kDebugMode ? _testAppOpenAdUnitId : _prodAppOpenAdUnitId;

  
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      
      MobileAds.initialize();
      _isInitialized = true;
    } catch (e) {
      
    }
  }

  
  BannerAdSize getBannerAdSize(int screenWidth, {int maxHeight = 250}) {
    return BannerAdSize.inline(width: screenWidth, maxHeight: maxHeight);
  }


  
  
}
