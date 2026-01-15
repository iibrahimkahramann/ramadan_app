import 'package:uuid/uuid.dart';

class Dhikr {
  final String id;
  final String title;
  final String? arabicTitle;
  final int count;
  final int target;

  Dhikr({
    String? id,
    required this.title,
    this.arabicTitle,
    this.count = 0,
    this.target = 33,
  }) : id = id ?? const Uuid().v4();

  Dhikr copyWith({
    String? title,
    String? arabicTitle,
    int? count,
    int? target,
  }) {
    return Dhikr(
      id: id,
      title: title ?? this.title,
      arabicTitle: arabicTitle ?? this.arabicTitle,
      count: count ?? this.count,
      target: target ?? this.target,
    );
  }
}
