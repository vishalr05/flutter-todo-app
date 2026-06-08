import 'package:flutter/material.dart';
import '../services/storage_service.dart';

/// ──────────────────────────────────────────────
/// Onboarding Provider
/// ──────────────────────────────────────────────
///
/// Manages whether the user has completed the onboarding flow.
/// The state is persisted in Hive so it survives app restarts.
class OnboardingProvider extends ChangeNotifier {
  final StorageService _storage = StorageService();

  /// Whether the user has seen and dismissed the onboarding screen.
  bool _isComplete = false;
  bool get isComplete => _isComplete;

  /// Load the onboarding state from Hive.
  /// Called once during app initialization.
  void loadState() {
    _isComplete = _storage.getOnboardingComplete();
    notifyListeners();
  }

  /// Mark onboarding as complete and persist the change.
  Future<void> completeOnboarding() async {
    _isComplete = true;
    await _storage.setOnboardingComplete(true);
    notifyListeners();
  }
}
