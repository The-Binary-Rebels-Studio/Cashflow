import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:yandex_mobileads/mobile_ads.dart';
import 'ads_service.dart';
import '../di/injection.dart';

/// Manages App Open Ads lifecycle and showing logic
/// Follows official Yandex example implementation
@singleton
class AppOpenAdManager {
  bool _loadingInProgress = false;
  AppOpenAd? _appOpenAd;
  late final Future<AppOpenAdLoader> _appOpenAdLoader;
  
  static bool isAdShowing = false;
  
  AppOpenAdManager() {
    // Lazy initialization to avoid dependency issues
    _appOpenAdLoader = _createAppOpenAdLoader();
  }
  
  AdsService get _adsService => getIt<AdsService>();
  
  AdRequestConfiguration get _adRequestConfiguration => AdRequestConfiguration(
    adUnitId: _adsService.appOpenAdUnitId,
  );
  
  bool get isLoaded => _appOpenAd != null;
  
  /// Create app open ad loader with event listeners
  Future<AppOpenAdLoader> _createAppOpenAdLoader() async {
    return AppOpenAdLoader.create(
      onAdLoaded: (AppOpenAd appOpenAd) {
        _appOpenAd = appOpenAd;
        _loadingInProgress = false;
        if (kDebugMode) {
          print('✅ App open ad loaded successfully');
        }
      },
      onAdFailedToLoad: (AdRequestError error) {
        _loadingInProgress = false;
        if (kDebugMode) {
          print('❌ App open ad failed to load: ${error.description}');
        }
        // Retry after delay
        Future.delayed(const Duration(seconds: 30), () {
          if (!isLoaded) loadAppOpenAd();
        });
      },
    );
  }
  
  /// Load app open ad
  Future<void> loadAppOpenAd() async {
    if (!_adsService.isInitialized) {
      await _adsService.initialize();
    }
    
    if (_loadingInProgress == false) {
      _loadingInProgress = true;
      final adLoader = await _appOpenAdLoader;
      adLoader.loadAd(adRequestConfiguration: _adRequestConfiguration);
    }
  }
  
  /// Show app open ad if available
  Future<void> showAdIfAvailable() async {
    final appOpenAd = _appOpenAd;
    if (appOpenAd != null && !isAdShowing) {
      _setAdEventListener(appOpenAd: appOpenAd);
      await appOpenAd.show();
      await appOpenAd.waitForDismiss();
    } else {
      loadAppOpenAd();
    }
  }
  
  /// Clear app open ad
  void clearAppOpenAd() {
    _appOpenAd?.destroy();
    _appOpenAd = null;
  }
  
  /// Set ad event listeners
  void _setAdEventListener({required AppOpenAd appOpenAd}) {
    appOpenAd.setAdEventListener(
      eventListener: AppOpenAdEventListener(
        onAdShown: () {
          isAdShowing = true;
          if (kDebugMode) {
            print('👁️ App open ad shown');
          }
        },
        onAdFailedToShow: (AdError error) {
          if (kDebugMode) {
            print('💥 Failed to show app open ad: ${error.description}');
          }
        },
        onAdDismissed: () {
          isAdShowing = false;
          clearAppOpenAd();
          loadAppOpenAd();
          if (kDebugMode) {
            print('🚪 App open ad dismissed');
          }
        },
        onAdClicked: () {
          if (kDebugMode) {
            print('👆 App open ad clicked');
          }
        },
        onAdImpression: (ImpressionData? data) {
          if (kDebugMode) {
            print('📊 App open ad impression recorded');
          }
        },
      ),
    );
  }
  
  /// Initialize and preload first ad
  Future<void> initialize() async {
    await loadAppOpenAd();
  }
  
  /// Dispose resources
  void dispose() {
    clearAppOpenAd();
  }
}