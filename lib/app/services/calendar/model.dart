import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

enum CalendarEventType { exam, home, vacation, event, stay }

@JsonSerializable(fieldRename: FieldRename.snake)
class CalendarEvent {
  final String title;
  final CalendarEventType type;
  final DateTime date;
  final String? description;

  CalendarEvent({required this.title, required this.type, required this.date, this.description});

  factory CalendarEvent.fromJson(Map<String, dynamic> json) =>
      _$CalendarEventFromJson(json);
  Map<String, dynamic> toJson() => _$CalendarEventToJson(this);
}