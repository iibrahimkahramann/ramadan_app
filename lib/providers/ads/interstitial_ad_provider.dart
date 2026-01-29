import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAdState {
  final InterstitialAd? interstitialAd;
  final bool isLoaded;

  InterstitialAdState({this.interstitialAd, this.isLoaded = false});

  InterstitialAdState copyWith({
    InterstitialAd? interstitialAd,
    bool? isLoaded,
  }) {
    return InterstitialAdState(
      interstitialAd: interstitialAd ?? this.interstitialAd,
      isLoaded: isLoaded ?? this.isLoaded,
    );
  }
}

class InterstitialAdNotifier extends StateNotifier<InterstitialAdState> {
  InterstitialAdNotifier() : super(InterstitialAdState()) {
    loadAd();
  }

  Future<void> loadAd() async {
    if (state.isLoaded || state.interstitialAd != null) return;

    final String adUnitId = Platform.isAndroid
        ? 'ca-app-pub-7069767836666175/5967359423'
        : 'ca-app-pub-7069767836666175/8639762400';

    InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          if (!mounted) return;
          state = state.copyWith(interstitialAd: ad, isLoaded: true);
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
          if (!mounted) return;
          state = state.copyWith(isLoaded: false);
        },
      ),
    );
  }

  void showAd({required VoidCallback onAdDismissed}) {
    if (state.isLoaded && state.interstitialAd != null) {
      state.interstitialAd!.fullScreenContentCallback =
          FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              onAdDismissed();
              if (mounted) {
                state = InterstitialAdState();
                loadAd();
              }
            },
            onAdFailedToShowFullScreenContent: (ad, err) {
              ad.dispose();
              onAdDismissed();
              if (mounted) {
                state = InterstitialAdState();
                loadAd();
              }
            },
          );
      state.interstitialAd!.show();
    } else {
      onAdDismissed();
      loadAd();
    }
  }

  @override
  void dispose() {
    state.interstitialAd?.dispose();
    super.dispose();
  }
}

final interstitialAdProvider =
    StateNotifierProvider<InterstitialAdNotifier, InterstitialAdState>((ref) {
      return InterstitialAdNotifier();
    });
