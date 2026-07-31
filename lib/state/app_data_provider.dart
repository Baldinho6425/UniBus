import 'package:flutter/foundation.dart';

import '../models/notice.dart';
import '../models/passenger.dart';
import '../models/trip.dart';

const String kDeparturePoint = 'Em frente ao Mercado Central';
const String kDestination = 'UNOESC – Campus I';
const String kDepartureTime = '06:30';
const int kSeatsTotal = 28;

/// Fonte única dos dados de viagens, passageiros e avisos.
///
/// Hoje mantém tudo em memória com dados de exemplo. Quando o Firestore for
/// configurado (ver README), troque os métodos de leitura/escrita abaixo por
/// chamadas à coleção correspondente e use `notifyListeners()` a partir de um
/// stream do Firestore.
class AppDataProvider extends ChangeNotifier {
  AppDataProvider() {
    _seed();
  }

  final List<Trip> _trips = [];
  final List<Passenger> _passengers = [];
  final List<Notice> _notices = [];

  List<Trip> get upcomingTrips => _trips.where((t) => t.status != TripStatus.past).toList();

  List<Trip> get pastTrips => _trips.where((t) => t.status == TripStatus.past).toList();

  Trip? get nextTrip {
    final list = upcomingTrips;
    if (list.isEmpty) return null;
    return list.first;
  }

  List<Passenger> get passengers => List.unmodifiable(_passengers);

  List<Passenger> get confirmedPassengers => _passengers.where((p) => p.confirmed).toList();

  List<Notice> get notices => List.unmodifiable(_notices);

  void confirmPresence(String tripId) {
    _updateTrip(tripId, TripStatus.confirmed);
  }

  void cancelPresence(String tripId) {
    _updateTrip(tripId, TripStatus.pending);
  }

  void _updateTrip(String tripId, TripStatus status) {
    final index = _trips.indexWhere((t) => t.id == tripId);
    if (index == -1) return;
    _trips[index] = _trips[index].copyWith(status: status);
    notifyListeners();
  }

  void _seed() {
    final now = DateTime.now();
    var cursor = DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
    var added = 0;
    var isFirst = true;
    while (added < 6) {
      if (cursor.weekday != DateTime.saturday && cursor.weekday != DateTime.sunday) {
        _trips.add(
          Trip(
            id: 't${added + 1}',
            date: cursor,
            departureTime: kDepartureTime,
            departurePoint: kDeparturePoint,
            destination: kDestination,
            seatsTaken: 16,
            seatsTotal: kSeatsTotal,
            status: isFirst ? TripStatus.confirmed : TripStatus.pending,
          ),
        );
        added++;
        isFirst = false;
      }
      cursor = cursor.add(const Duration(days: 1));
    }

    const names = [
      'Eduardo A. Giehl',
      'Ana Clara B.',
      'Bruno Henrique',
      'Caroline M.',
      'Gustavo L.',
      'Isabela V.',
      'João Pedro',
      'Larissa T.',
      'Mariana S.',
      'Rafael O.',
      'Camila F.',
      'Diego A.',
      'Fernanda R.',
      'Henrique P.',
      'Juliana K.',
      'Vinícius N.',
    ];
    for (var i = 0; i < names.length; i++) {
      _passengers.add(Passenger(id: 'p$i', name: names[i], confirmed: true));
    }

    _notices.addAll([
      Notice(
        id: 'n1',
        title: 'Manutenção no ônibus',
        message: 'Na próxima segunda (04/08) o ônibus passará por manutenção preventiva.',
        date: now.subtract(const Duration(hours: 3)),
        type: NoticeType.info,
      ),
      Notice(
        id: 'n2',
        title: 'Atenção, passageiros!',
        message: 'Cheguem com 5 minutos de antecedência no ponto de saída.',
        date: now.subtract(const Duration(days: 4)),
        type: NoticeType.warning,
      ),
      Notice(
        id: 'n3',
        title: 'Viagem extra confirmada',
        message: 'Sábado (02/08) haverá viagem extra às 12:30 para atividades acadêmicas.',
        date: now.subtract(const Duration(days: 4, hours: 6)),
        type: NoticeType.success,
      ),
    ]);
  }
}
