import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

enum CalendarEventType { exam, home, vacation, event, stay }

@JsonSerializable(fieldRename: FieldRename.snake)
class CalendarEvent {
  final String title;
  final CalendarEventType type;
  final DateTime date;
  final String? description;

  CalendarEvent({
    required this.title,
    required this.type,
    required this.date,
    this.description,
  });

  factory CalendarEvent.fromJson(Map<String, dynamic> json) =>
      _$CalendarEventFromJson(json);
  Map<String, dynamic> toJson() => _$CalendarEventToJson(this);
}

class CalendarTodoItem {
  final String id;
  final DateTime date;
  final String title;
  final bool isDone;

  const CalendarTodoItem({
    required this.id,
    required this.date,
    required this.title,
    this.isDone = false,
  });

  CalendarTodoItem copyWith({
    String? id,
    DateTime? date,
    String? title,
    bool? isDone,
  }) {
    return CalendarTodoItem(
      id: id ?? this.id,
      date: date ?? this.date,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
    );
  }
}
