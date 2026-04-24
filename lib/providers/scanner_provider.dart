import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifiers/scanner_notifier.dart';

export '../notifiers/scanner_notifier.dart'
    show ScannerState, ScannerNotifier, ScanPhase;
export '../models/scanner/detected_food.dart' show ScanMode;

final scannerProvider = NotifierProvider<ScannerNotifier, ScannerState>(() {
  return ScannerNotifier();
});
