import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

@JsonSerializable()
class NotificationSubject {
  final String id;
  final String description;

  NotificationSubject({
    required this.id,
    required this.description,
  });

  factory NotificationSubject.fromJson(Map<String, dynamic> json) =>
      _$NotificationSubjectFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationSubjectToJson(this);
}
