import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ramadan_app/models/dhikr/dhikr_model.dart';

class DhikrState {
  final List<Dhikr> dhikrs;
  final String activeDhikrId;

  DhikrState({required this.dhikrs, required this.activeDhikrId});

  Dhikr get activeDhikr => dhikrs.firstWhere((d) => d.id == activeDhikrId);

  DhikrState copyWith({List<Dhikr>? dhikrs, String? activeDhikrId}) {
    return DhikrState(
      dhikrs: dhikrs ?? this.dhikrs,
      activeDhikrId: activeDhikrId ?? this.activeDhikrId,
    );
  }
}

class DhikrNotifier extends Notifier<DhikrState> {
  @override
  DhikrState build() {
    final initialDhikrs = [
      Dhikr(title: 'Subhanallah', arabicTitle: 'سبحان الله', target: 33),
      Dhikr(title: 'Alhamdulillah', arabicTitle: 'الحمد لله', target: 33),
      Dhikr(title: 'Allahu Akbar', arabicTitle: 'الله أكبر', target: 33),
    ];
    return DhikrState(
      dhikrs: initialDhikrs,
      activeDhikrId: initialDhikrs.first.id,
    );
  }

  void increment() {
    final updatedDhikrs = state.dhikrs.map((d) {
      if (d.id == state.activeDhikrId) {
        return d.copyWith(count: d.count + 1);
      }
      return d;
    }).toList();
    state = state.copyWith(dhikrs: updatedDhikrs);
  }

  void reset() {
    final updatedDhikrs = state.dhikrs.map((d) {
      if (d.id == state.activeDhikrId) {
        return d.copyWith(count: 0);
      }
      return d;
    }).toList();
    state = state.copyWith(dhikrs: updatedDhikrs);
  }

  void selectDhikr(String id) {
    state = state.copyWith(activeDhikrId: id);
  }

  void addDhikr(String title, int target) {
    final newDhikr = Dhikr(title: title, target: target);
    state = state.copyWith(
      dhikrs: [...state.dhikrs, newDhikr],
      activeDhikrId: newDhikr.id,
    );
  }

  void deleteDhikr(String id) {
    if (state.dhikrs.length <= 1) return;

    final updatedDhikrs = state.dhikrs.where((d) => d.id != id).toList();

    String newActiveId = state.activeDhikrId;
    if (state.activeDhikrId == id) {
      newActiveId = updatedDhikrs.first.id;
    }

    state = state.copyWith(dhikrs: updatedDhikrs, activeDhikrId: newActiveId);
  }
}

final dhikrProvider = NotifierProvider<DhikrNotifier, DhikrState>(() {
  return DhikrNotifier();
});
