import 'package:uuid/uuid.dart';


class History {
  final String text;
  final DateTime time;
  String historyId;

  History({
    required this.text,
    required this.time,
    String? historyId,
  }) : historyId = historyId ?? Uuid().v4();

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'time': time.toIso8601String(),
      'historyId': historyId,
    };
  }
  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      text: json['text'],
      time: DateTime.parse(json['time']), // Menggunakan parse untuk mengonversi string ISO8601 ke DateTime
      historyId: json['history_id'],
    );
  }
}


