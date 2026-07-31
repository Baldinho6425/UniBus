enum NoticeType { info, warning, success }

class Notice {
  final String id;
  final String title;
  final String message;
  final DateTime date;
  final NoticeType type;

  const Notice({
    required this.id,
    required this.title,
    required this.message,
    required this.date,
    required this.type,
  });
}
