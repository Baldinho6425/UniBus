class AppUser {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String course;
  final String semester;
  final String municipality;
  final String boardingPoint;
  final bool notificationsEnabled;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.course = '',
    this.semester = '',
    this.municipality = '',
    this.boardingPoint = '',
    this.notificationsEnabled = true,
  });

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1)).toUpperCase();
  }

  AppUser copyWith({
    String? name,
    String? email,
    String? phone,
    String? course,
    String? semester,
    String? municipality,
    String? boardingPoint,
    bool? notificationsEnabled,
  }) {
    return AppUser(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      course: course ?? this.course,
      semester: semester ?? this.semester,
      municipality: municipality ?? this.municipality,
      boardingPoint: boardingPoint ?? this.boardingPoint,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}
