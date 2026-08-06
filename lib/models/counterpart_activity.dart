/// Uma vaga/atividade de contrapartida (horas de trabalho comunitário).
class CounterpartActivity {
  final String id;
  final String title;
  final String description;
  final String location;
  final DateTime date;
  final String startTime;
  final String endTime;
  final String responsible;
  final int hours;
  final int totalSlots;
  final int takenSlots;
  final bool enrolled;
  final bool completed;

  const CounterpartActivity({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.responsible,
    required this.hours,
    required this.totalSlots,
    required this.takenSlots,
    this.enrolled = false,
    this.completed = false,
  });

  int get slotsAvailable => totalSlots - takenSlots;

  CounterpartActivity copyWith({bool? enrolled, int? takenSlots, bool? completed}) {
    return CounterpartActivity(
      id: id,
      title: title,
      description: description,
      location: location,
      date: date,
      startTime: startTime,
      endTime: endTime,
      responsible: responsible,
      hours: hours,
      totalSlots: totalSlots,
      takenSlots: takenSlots ?? this.takenSlots,
      enrolled: enrolled ?? this.enrolled,
      completed: completed ?? this.completed,
    );
  }
}
