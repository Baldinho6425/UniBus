class AppUser {
  final String id;
  final String name;
  final String email;
  final String phone;
  final bool notificationsEnabled;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
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
    bool? notificationsEnabled,
  }) {
    return AppUser(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}
