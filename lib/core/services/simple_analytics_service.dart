import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:injectable/injectable.dart';

@singleton
class SimpleAnalyticsService {
  late final FirebaseAnalytics _analytics;
  
  void initialize() {
    _analytics = FirebaseAnalytics.instance;
  }

  // Core tracking methods
  Future<void> logScreenView(String screenName) async {
    await _analytics.logScreenView(screenName: screenName);
  }

  Future<void> logButtonPress(String buttonName, String screenName) async {
    await _analytics.logEvent(
      name: 'button_press',
      parameters: {
        'button_name': buttonName,
        'screen_name': screenName,
      },
    );
  }

  Future<void> logFeatureUsage(String featureName) async {
    await _analytics.logEvent(
      name: 'feature_usage',
      parameters: {
        'feature_name': featureName,
      },
    );
  }

  Future<void> logTransactionAction(String action, String type) async {
    await _analytics.logEvent(
      name: 'transaction_action',
      parameters: {
        'action': action, // 'create', 'edit', 'delete'
        'type': type, // 'income', 'expense'
      },
    );
  }

  Future<void> logBudgetAction(String action) async {
    await _analytics.logEvent(
      name: 'budget_action',
      parameters: {
        'action': action, // 'create', 'edit', 'delete'
      },
    );
  }

  Future<void> logNavigation(String fromScreen, String toScreen) async {
    await _analytics.logEvent(
      name: 'navigation',
      parameters: {
        'from_screen': fromScreen,
        'to_screen': toScreen,
      },
    );
  }

  Future<void> logAppOpen() async {
    await _analytics.logAppOpen();
  }

  Future<void> logAdInteraction(String adType, String action) async {
    await _analytics.logEvent(
      name: 'ad_interaction',
      parameters: {
        'ad_type': adType, // 'banner', 'interstitial', 'native'
        'action': action, // 'shown', 'clicked', 'closed'
      },
    );
  }

  Future<void> logScreenTimeSpent(String screenName, int seconds) async {
    await _analytics.logEvent(
      name: 'screen_time',
      parameters: {
        'screen_name': screenName,
        'time_seconds': seconds,
        'time_category': _getTimeCategory(seconds),
      },
    );
  }

  Future<void> logUserEngagement(String engagementType, String screenName) async {
    await _analytics.logEvent(
      name: 'user_engagement',
      parameters: {
        'engagement_type': engagementType, // 'scroll', 'swipe', 'refresh'
        'screen_name': screenName,
      },
    );
  }

  Future<void> logDataVisualiation(String chartType, String dataRange) async {
    await _analytics.logEvent(
      name: 'data_visualization',
      parameters: {
        'chart_type': chartType,
        'data_range': dataRange,
      },
    );
  }

  Future<void> logUserRetention(String sessionType, int daysSinceLastUse) async {
    await _analytics.logEvent(
      name: 'user_retention',
      parameters: {
        'session_type': sessionType,
        'days_since_last_use': daysSinceLastUse,
        'retention_category': _getRetentionCategory(daysSinceLastUse),
      },
    );
  }

  Future<void> logContentInteraction(String contentType, String action, String location) async {
    await _analytics.logEvent(
      name: 'content_interaction',
      parameters: {
        'content_type': contentType,
        'action': action,
        'location': location,
      },
    );
  }

  Future<void> logUserPreference(String preferenceType, String value) async {
    await _analytics.logEvent(
      name: 'user_preference',
      parameters: {
        'preference_type': preferenceType,
        'preference_value': value,
      },
    );
  }

  Future<void> logFinancialGoal(String goalType, String action) async {
    await _analytics.logEvent(
      name: 'financial_goal',
      parameters: {
        'goal_type': goalType,
        'action': action,
      },
    );
  }

  Future<void> logDataAccuracy(String dataType, String accuracyLevel) async {
    await _analytics.logEvent(
      name: 'data_accuracy',
      parameters: {
        'data_type': dataType,
        'accuracy_level': accuracyLevel,
      },
    );
  }

  Future<void> logUserFeedback(String feedbackType, int rating) async {
    await _analytics.logEvent(
      name: 'user_feedback',
      parameters: {
        'feedback_type': feedbackType,
        'rating': rating,
        'rating_category': _getRatingCategory(rating),
      },
    );
  }

  String _getTimeCategory(int seconds) {
    if (seconds < 10) return 'quick';
    if (seconds < 30) return 'short';
    if (seconds < 60) return 'medium';
    if (seconds < 300) return 'long';
    return 'extended';
  }

  String _getRetentionCategory(int days) {
    if (days == 0) return 'same_day';
    if (days == 1) return 'next_day';
    if (days <= 7) return 'weekly';
    if (days <= 30) return 'monthly';
    return 'returning';
  }

  String _getRatingCategory(int rating) {
    if (rating <= 2) return 'poor';
    if (rating <= 3) return 'average';
    if (rating <= 4) return 'good';
    return 'excellent';
  }
}