enum TripStatus { pending, confirmed, cancelled, past }

class Trip {
  final String id;
  final DateTime date;
  final String departureTime;
  final String departurePoint;
  final String destination;
  final int seatsTaken;
  final int seatsTotal;
  final TripStatus status;

  const Trip({
    required this.id,
    required this.date,
    required this.departureTime,
    required this.departurePoint,
    required this.destination,
    required this.seatsTaken,
    required this.seatsTotal,
    required this.status,
  });

  int get seatsAvailable => seatsTotal - seatsTaken;

  Trip copyWith({TripStatus? status, int? seatsTaken}) {
    return Trip(
      id: id,
      date: date,
      departureTime: departureTime,
      departurePoint: departurePoint,
      destination: destination,
      seatsTaken: seatsTaken ?? this.seatsTaken,
      seatsTotal: seatsTotal,
      status: status ?? this.status,
    );
  }
}
