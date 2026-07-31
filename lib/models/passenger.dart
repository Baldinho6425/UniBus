class Passenger {
  final String id;
  final String name;
  final bool confirmed;

  const Passenger({
    required this.id,
    required this.name,
    required this.confirmed,
  });

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1)).toUpperCase();
  }
}
