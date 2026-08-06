enum NoticeCategory { transporte, contrapartidas, eventos, urgente }

class Notice {
  final String id;
  final String title;
  final String message;
  final DateTime date;
  final NoticeCategory category;
  final bool isRead;

  const Notice({
    required this.id,
    required this.title,
    required this.message,
    required this.date,
    required this.category,
    this.isRead = false,
  });

  Notice copyWith({bool? isRead}) {
    return Notice(
      id: id,
      title: title,
      message: message,
      date: date,
      category: category,
      isRead: isRead ?? this.isRead,
    );
  }
}
