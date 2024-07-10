class JournalLog {
  final int id;
  final dynamic act;
  final String city;
  final String? comment;
  final int? content_type;
  final String? created_at;
  final dynamic creator;
  final String? description;
  final dynamic document;
  final String? duration;
  final String? end_date;
  final dynamic executor;
  final bool overdue;
  final dynamic personal_account;
  final int? personal_account_id;
  final String? planned_end_date;
  final String? sector;
  final String? status;
  final String? theme;
  final String? updated_at;

  JournalLog({
    required this.id,
    this.act,
    required this.city,
    this.comment,
    this.content_type,
    this.created_at,
    this.creator,
    this.description,
    this.document,
    this.duration,
    this.end_date,
    this.executor,
    required this.overdue,
    this.personal_account,
    this.personal_account_id,
    this.planned_end_date,
    this.sector,
    this.status,
    this.theme,
    this.updated_at,
  });

  factory JournalLog.fromJson(Map<String, dynamic> json) {
    return JournalLog(
      id: json['id'],
      content_type: json['content_type'],
      city: json['city'],
      comment: json['comment'],
      created_at: json['created_at'],
      description: json['description'],
      duration: json['duration'],
      end_date: json['end_date'],
      planned_end_date: json['planned_end_date'],
      sector: json['sector'],
      status: json['status'],
      theme: json['theme'],
      updated_at: json['updated_at'],
      act: json['act'],
      creator: json['creator'],
      document: json['document'],
      executor: json['executor'],
      overdue: json['overdue'],
      personal_account: json['personal_account'],
      personal_account_id: json['personal_account_id'],
    );
  }
}
