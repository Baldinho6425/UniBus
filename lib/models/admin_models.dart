import '../models/notice.dart';

class AdminTripRow {
  final String route;
  final DateTime date;
  final String departureTime;
  final String destination;
  final String busName;
  final int confirmed;
  final int capacity;

  const AdminTripRow({
    required this.route,
    required this.date,
    required this.departureTime,
    required this.destination,
    required this.busName,
    required this.confirmed,
    required this.capacity,
  });
}

class BusOccupancy {
  final String name;
  final int percent;

  const BusOccupancy({required this.name, required this.percent});
}

class RecentCounterpart {
  final String title;
  final DateTime date;
  final String startTime;
  final String endTime;
  final int hours;
  final int totalSlots;
  final int enrolled;

  const RecentCounterpart({
    required this.title,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.hours,
    required this.totalSlots,
    required this.enrolled,
  });
}

class AdminNoticeSummary {
  final String title;
  final NoticeCategory category;
  final DateTime sentAt;

  const AdminNoticeSummary({required this.title, required this.category, required this.sentAt});
}
