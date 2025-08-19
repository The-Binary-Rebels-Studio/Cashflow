import 'package:flutter/material.dart';
import 'package:yandex_mobileads/mobile_ads.dart';
import '../../core/di/injection.dart';
import '../../core/services/ads_service.dart';
import '../../core/services/simple_analytics_service.dart';

class BannerAdWidget extends StatefulWidget {
  final double? height;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final VoidCallback? onAdLoaded;
  final VoidCallback? onAdFailed;
  final int maxHeight;

  const BannerAdWidget({
    super.key,
    this.height,
    this.borderRadius,
    this.backgroundColor,
    this.onAdLoaded,
    this.onAdFailed,
    this.maxHeight = 250,
  });

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  late final AdsService _adsService;
  late final SimpleAnalyticsService _analyticsService;
  BannerAd? _bannerAd;
  bool _isLoading = false;
  bool _isBannerAlreadyCreated = false;

  @override
  void initState() {
    super.initState();
    _adsService = getIt<AdsService>();
    _analyticsService = getIt<SimpleAnalyticsService>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isBannerAlreadyCreated && !_isLoading && _adsService.isInitialized) {
      _loadBanner();
    }
  }

  Future<void> _loadBanner() async {
    if (!mounted || _isBannerAlreadyCreated || _isLoading) return;

    setState(() => _isLoading = true);

    try {
      final windowSize = MediaQuery.of(context).size;

      final adSize = BannerAdSize.inline(
        width: windowSize.width.toInt(),
        maxHeight: widget.maxHeight,
      );

      _bannerAd = _createBanner(adSize);

      if (mounted) {
        setState(() {
          _isBannerAlreadyCreated = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        widget.onAdFailed?.call();
      }
    }
  }

  BannerAd _createBanner(BannerAdSize adSize) {
    return BannerAd(
      adUnitId: _adsService.bannerAdUnitId,
      adSize: adSize,
      adRequest: const AdRequest(),
      onAdLoaded: () {
        if (mounted) {
          // Analytics tracking for successful ad load
          _analyticsService.logAdInteraction('banner', 'loaded');
          _analyticsService.logContentInteraction(
            'banner_ad',
            'load_success',
            'screen',
          );

          setState(() {
            _isLoading = false;
          });
          widget.onAdLoaded?.call();
        }
      },
      onAdFailedToLoad: (error) {
        if (mounted) {
          // Analytics tracking for failed ad load
          _analyticsService.logAdInteraction('banner', 'load_failed');
          _analyticsService.logContentInteraction(
            'banner_ad',
            'load_error',
            error.description,
          );

          setState(() {
            _isLoading = false;
            _isBannerAlreadyCreated = false;
          });
          widget.onAdFailed?.call();
        }
      },
      onAdClicked: () {
        _analyticsService.logAdInteraction('banner', 'clicked');
        _analyticsService.logContentInteraction(
          'banner_ad',
          'user_click',
          'engagement',
        );
        _analyticsService.logUserEngagement('ad_click', 'banner_widget');
      },
      onLeftApplication: () {
        _analyticsService.logAdInteraction('banner', 'left_app');
        _analyticsService.logUserEngagement('app_exit', 'ad_redirect');
      },
      onReturnedToApplication: () {
        _analyticsService.logAdInteraction('banner', 'returned_to_app');
        _analyticsService.logUserEngagement('app_return', 'after_ad');
      },
      onImpression: (data) {
        _analyticsService.logAdInteraction('banner', 'impression');
        _analyticsService.logContentInteraction(
          'banner_ad',
          'view_impression',
          'visibility',
        );
      },
      onAdClose: () {
        if (mounted) {
          _analyticsService.logAdInteraction('banner', 'closed');
          _analyticsService.logUserEngagement('ad_dismiss', 'banner_widget');
          setState(() => _isBannerAlreadyCreated = false);
        }
      },
    );
  }

  @override
  void dispose() {
    _bannerAd?.destroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_bannerAd == null) {
      return const SizedBox.shrink();
    }

    return AdWidget(bannerAd: _bannerAd!);
  }
}
