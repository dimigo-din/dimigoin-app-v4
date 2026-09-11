/// snake_case가 camelCase로 바뀌어도 깨지지 않도록 두 표기 모두 읽는다.
String _readString(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];
    if (value is String) return value;
  }
  return '';
}

/// 학생은 잃어버린 물건만 제보하고, 작성자가 물건을 찾으면 found 로 바꿉니다.
enum LostfoundStatus {
  lost('lost', '분실'),
  found('found', '회수');

  final String value;
  final String label;

  const LostfoundStatus(this.value, this.label);

  static LostfoundStatus fromValue(String? value) {
    return LostfoundStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => LostfoundStatus.lost,
    );
  }
}

class LostfoundImg {
  final String id;
  final String name;
  final String url;

  LostfoundImg({required this.id, required this.name, required this.url});

  factory LostfoundImg.fromJson(Map<String, dynamic> json) {
    return LostfoundImg(
      id: _readString(json, ['id']),
      name: _readString(json, ['name']),
      url: _readString(json, ['url']),
    );
  }
}

class LostfoundComment {
  final String id;
  final String parentId;
  final String text;
  final String createdAt;
  final String userId;

  /// 서버가 작성자를 내려주지 않으면 null
  final String? userName;

  LostfoundComment({
    required this.id,
    required this.parentId,
    required this.text,
    required this.createdAt,
    required this.userId,
    required this.userName,
  });

  factory LostfoundComment.fromJson(Map<String, dynamic> json) {
    final user = json['user'];
    final userMap = user is Map<String, dynamic> ? user : const <String, dynamic>{};

    return LostfoundComment(
      id: _readString(json, ['id']),
      parentId: _readString(json, ['parent_id', 'parentId']),
      text: _readString(json, ['text']),
      createdAt: _readString(json, ['created_at', 'createdAt']),
      userId: _readString(json, ['user_id', 'userId']),
      userName: userMap['name'] is String ? userMap['name'] as String : null,
    );
  }
}

class LostfoundReport {
  final String id;
  final LostfoundStatus status;
  final String objectName;
  final String lastSeenPlace;
  final String body;
  final String createdAt;
  final List<LostfoundImg> img;
  final List<LostfoundComment> comment;
  final String userId;

  final String? userName;

  LostfoundReport({
    required this.id,
    required this.status,
    required this.objectName,
    required this.lastSeenPlace,
    required this.body,
    required this.createdAt,
    required this.img,
    required this.comment,
    required this.userId,
    required this.userName,
  });

  factory LostfoundReport.fromJson(Map<String, dynamic> json) {
    final user = json['user'];
    final userMap = user is Map<String, dynamic> ? user : const <String, dynamic>{};

    return LostfoundReport(
      id: _readString(json, ['id']),
      status: LostfoundStatus.fromValue(json['status'] as String?),
      objectName: _readString(json, ['object_name', 'objectName']),
      lastSeenPlace: _readString(json, ['last_seen_place', 'lastSeenPlace']),
      body: _readString(json, ['body']),
      createdAt: _readString(json, ['created_at', 'createdAt']),
      img: ((json['img'] ?? []) as List)
          .map((e) => LostfoundImg.fromJson(e as Map<String, dynamic>))
          .toList(),
      comment: ((json['comment'] ?? []) as List)
          .map((e) => LostfoundComment.fromJson(e as Map<String, dynamic>))
          .toList(),
      userId: _readString(json, ['user_id', 'userId']),
      userName: userMap['name'] is String ? userMap['name'] as String : null,
    );
  }
}
