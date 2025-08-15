import 'package:injectable/injectable.dart';
import 'package:yandex_mobileads/mobile_ads.dart';
import 'ads_service.dart';
import '../di/injection.dart';


@singleton
class AppOpenAdManager {
  bool _loadingInProgress = false;
  AppOpenAd? _appOpenAd;
  late final Future<AppOpenAdLoader> _appOpenAdLoader;
  
  static bool isAdShowing = false;
  
  AppOpenAdManager() {
    
    _appOpenAdLoader = _createAppOpenAdLoader();
  }
  
  AdsService get _adsService => getIt<AdsService>();
  
  AdRequestConfiguration get _adRequestConfiguration => AdRequestConfiguration(
    adUnitId: _adsService.appOpenAdUnitId,
  );
  
  bool get isLoaded => _appOpenAd != null;
  
  
  Future<AppOpenAdLoader> _createAppOpenAdLoader() async {
    return AppOpenAdLoader.create(
      onAdLoaded: (AppOpenAd appOpenAd) {
        _appOpenAd = appOpenAd;
        _loadingInProgress = false;
      },
      onAdFailedToLoad: (AdRequestError error) {
        _loadingInProgress = false;
        
        Future.delayed(const Duration(seconds: 30), () {
          if (!isLoaded) loadAppOpenAd();
        });
      },
    );
  }
  
  
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
  
  
  void clearAppOpenAd() {
    _appOpenAd?.destroy();
    _appOpenAd = null;
  }
  
  
  void _setAdEventListener({required AppOpenAd appOpenAd}) {
    appOpenAd.setAdEventListener(
      eventListener: AppOpenAdEventListener(
        onAdShown: () {
          isAdShowing = true;
        },
        onAdFailedToShow: (AdError error) {
        },
        onAdDismissed: () {
          isAdShowing = false;
          clearAppOpenAd();
          loadAppOpenAd();
        },
        onAdClicked: () {
        },
        onAdImpression: (ImpressionData? data) {
        },
      ),
    );
  }
  
  
  Future<void> initialize() async {
    await loadAppOpenAd();
  }
  
  
  void dispose() {
    clearAppOpenAd();
  }
}