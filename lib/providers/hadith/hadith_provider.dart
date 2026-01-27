import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../models/hadith/hadith_model.dart';
import 'dart:math';

class HadithState {
  final List<Hadith> hadiths;
  final bool isLoading;
  final String? errorMessage;

  HadithState({
    this.hadiths = const [],
    this.isLoading = true,
    this.errorMessage,
  });

  HadithState copyWith({
    List<Hadith>? hadiths,
    bool? isLoading,
    String? errorMessage,
  }) {
    return HadithState(
      hadiths: hadiths ?? this.hadiths,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class HadithNotifier extends Notifier<HadithState> {
  @override
  HadithState build() {
    Future.microtask(() => _fetchHadiths());
    return HadithState();
  }

  Future<void> _fetchHadiths() async {
    try {
      // Using Sahih Bukhari (English) - Fetches a subset to avoid huge download if possible, or handle large JSON
      // fawazahmed0/hadith-api structure usually returns a large JSON with "hadiths" array

      // Note: The file for the entire Bukhari is ~16MB. Downloading it all might be heavy.
      // There are section based endpoints, but for simplicity let's try a smaller collection or random approach if possible.
      // Or we accept the download size (it's text, compresses well).

      // Using a reputable CDN for stability
      final url = Uri.parse(
        'https://cdn.jsdelivr.net/gh/fawazahmed0/hadith-api@1/editions/eng-bukhari.json',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> hadithsJson = data['hadiths'] ?? [];

        // Take a random subset of 50 hadiths to show (or all if performance allows)
        // Showing 50 random ones keeps the UI snappy and fresh
        final random = Random();
        final List<Hadith> allHadiths = hadithsJson
            .map((e) => Hadith.fromJson(e))
            .toList();

        // Shuffle and take 50
        allHadiths.shuffle(random);
        final List<Hadith> selectedHadiths = allHadiths.take(50).toList();

        state = state.copyWith(hadiths: selectedHadiths, isLoading: false);
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage:
              'Failed to load Hadiths (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error loading Hadiths: $e',
      );
    }
  }
}

final hadithProvider = NotifierProvider<HadithNotifier, HadithState>(() {
  return HadithNotifier();
});
