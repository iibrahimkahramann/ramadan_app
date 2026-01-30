import 'package:flutter_riverpod/legacy.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PremiumNotifier extends StateNotifier<bool> {
  PremiumNotifier() : super(false) {
    checkPremiumStatus();
    // Listen to changes
    Purchases.addCustomerInfoUpdateListener((customerInfo) {
      _updateStatus(customerInfo);
    });
  }

  Future<void> checkPremiumStatus() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      _updateStatus(customerInfo);
    } catch (e) {
      print('Failed to check premium status: $e');
    }
  }

  void _updateStatus(CustomerInfo customerInfo) {
    if (customerInfo.entitlements.all['premium']?.isActive ?? false) {
      state = true;
    } else {
      state = false;
    }
  }

  Future<void> updatePremiumStatus(bool isPremium) async {
    state = isPremium;
  }
}

final isPremiumProvider = StateNotifierProvider<PremiumNotifier, bool>((ref) {
  return PremiumNotifier();
});

final homePaywallShownProvider = StateProvider<bool>((ref) => false);
