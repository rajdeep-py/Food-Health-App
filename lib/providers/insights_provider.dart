import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifiers/insights_notifier.dart';

final insightsProvider = NotifierProvider<InsightsNotifier, InsightsState>(() {
  return InsightsNotifier();
});
