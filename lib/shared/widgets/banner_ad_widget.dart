import 'package:flutter/material.dart';
import 'package:yandex_mobileads/mobile_ads.dart';
import '../../core/di/injection.dart';
import '../../core/services/ads_service.dart';
import '../../core/services/simple_analytics_service.dart';


class BannerAdWidget extends StatefulWidget {
  final double? height; 
  final EdgeInsets margin;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final VoidCallback? onAdLoaded;
  final VoidCallback? onAdFailed;
  final int maxHeight; 

  const BannerAdWidget({
    super.key,
    this.height,
    this.margin = const EdgeInsets.all(8),
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
  bool _hasError = false;
  bool _isBannerAlreadyCreated = false; 
  double _actualHeight = 60;

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
    
    if (!_adsService.isInitialized) {
      setState(() {
        _hasError = true;
      });
      return;
    }

    setState(() => _isLoading = true);

    try {
      final windowSize = MediaQuery.of(context).size;
      
      
      final adSize = BannerAdSize.inline(
        width: windowSize.width.toInt(),
        maxHeight: widget.maxHeight,
      );
      
      
      final calculatedBannerSize = await adSize.getCalculatedBannerAdSize();
      if (mounted) {
        setState(() {
          _actualHeight = calculatedBannerSize.height.toDouble();
        });
      }
      
      
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
          _hasError = true;
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
          _analyticsService.logContentInteraction('banner_ad', 'load_success', 'screen');
          
          setState(() {
            _isLoading = false;
            _hasError = false;
          });
          widget.onAdLoaded?.call();
        }
      },
      onAdFailedToLoad: (error) {
        if (mounted) {
          // Analytics tracking for failed ad load
          _analyticsService.logAdInteraction('banner', 'load_failed');
          _analyticsService.logContentInteraction('banner_ad', 'load_error', error.description);
          
          setState(() {
            _isLoading = false;
            _hasError = true;
            _isBannerAlreadyCreated = false;
          });
          widget.onAdFailed?.call();
        }
      },
      onAdClicked: () {
        // Analytics tracking for ad clicks
        _analyticsService.logAdInteraction('banner', 'clicked');
        _analyticsService.logContentInteraction('banner_ad', 'user_click', 'engagement');
        _analyticsService.logUserEngagement('ad_click', 'banner_widget');
      },
      onLeftApplication: () {
        // Analytics tracking when user leaves app
        _analyticsService.logAdInteraction('banner', 'left_app');
        _analyticsService.logUserEngagement('app_exit', 'ad_redirect');
      },
      onReturnedToApplication: () {
        // Analytics tracking when user returns to app
        _analyticsService.logAdInteraction('banner', 'returned_to_app');
        _analyticsService.logUserEngagement('app_return', 'after_ad');
      },
      onImpression: (data) {
        // Analytics tracking for ad impressions
        _analyticsService.logAdInteraction('banner', 'impression');
        _analyticsService.logContentInteraction('banner_ad', 'view_impression', 'visibility');
      },
      onAdClose: () {
        if (mounted) {
          // Analytics tracking for ad close
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
    
    final containerHeight = _isLoading || _hasError 
        ? (widget.height ?? 60) 
        : _actualHeight;
    
    return Container(
      height: containerHeight,
      width: double.infinity, 
      margin: widget.margin,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Colors.grey[50],
        borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    if (_hasError || !_isBannerAlreadyCreated || _bannerAd == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.ad_units_outlined,
              color: Colors.grey[400],
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              'Banner Ad',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    
    return AdWidget(bannerAd: _bannerAd!);
  }
}