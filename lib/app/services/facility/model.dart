class FacilityReport {
  final String id;
  final String status;
  final String reportType;
  final String subject;
  final String body;
  final String createdAt;

  FacilityReport({
    required this.id,
    required this.status,
    required this.reportType,
    required this.subject,
    required this.body,
    required this.createdAt,
  });

  factory FacilityReport.fromJson(Map<String, dynamic> json) {
    return FacilityReport(
      id: json['id'] as String,
      status: json['status'] as String? ?? '',
      reportType: json['report_type'] as String? ?? '',
      subject: json['subject'] as String? ?? '',
      body: json['body'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
    );
  }
}
