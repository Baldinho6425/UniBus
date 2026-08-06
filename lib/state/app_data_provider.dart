import 'package:flutter/foundation.dart';

import '../models/counterpart_activity.dart';
import '../models/notice.dart';
import '../models/passenger.dart';
import '../models/trip.dart';

const String kDeparturePoint = 'Em frente ao Mercado Central';
const String kDestination = 'UNOESC – Campus I';
const String kDepartureTime = '06:30';
const int kSeatsTotal = 28;
const int kCounterpartRequiredHours = 40;

/// Fonte única dos dados de viagens, passageiros, avisos e contrapartidas.
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
  final List<CounterpartActivity> _counterpartActivities = [];
  late DateTime _counterpartDeadline;

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

  int get unreadNoticesCount => _notices.where((n) => !n.isRead).length;

  DateTime get counterpartDeadline => _counterpartDeadline;

  int get counterpartRequiredHours => kCounterpartRequiredHours;

  int get counterpartCompletedHours =>
      _counterpartActivities.where((a) => a.completed).fold(0, (sum, a) => sum + a.hours);

  int get counterpartPendingHours =>
      (counterpartRequiredHours - counterpartCompletedHours).clamp(0, counterpartRequiredHours);

  List<CounterpartActivity> get availableCounterpartActivities {
    final list = _counterpartActivities.where((a) => !a.completed && !a.enrolled).toList();
    list.sort((a, b) => a.date.compareTo(b.date));
    return list;
  }

  List<CounterpartActivity> get myCounterpartActivities {
    final list = _counterpartActivities.where((a) => !a.completed && a.enrolled).toList();
    list.sort((a, b) => a.date.compareTo(b.date));
    return list;
  }

  List<CounterpartActivity> get counterpartHistory {
    final list = _counterpartActivities.where((a) => a.completed).toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  CounterpartActivity? get nextCounterpartActivity {
    final list = _counterpartActivities.where((a) => !a.completed).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    if (list.isEmpty) return null;
    return list.first;
  }

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

  void enrollInCounterpart(String activityId) {
    final index = _counterpartActivities.indexWhere((a) => a.id == activityId);
    if (index == -1) return;
    final activity = _counterpartActivities[index];
    if (activity.enrolled || activity.slotsAvailable <= 0) return;
    _counterpartActivities[index] = activity.copyWith(enrolled: true, takenSlots: activity.takenSlots + 1);
    notifyListeners();
  }

  void markNoticeRead(String noticeId) {
    final index = _notices.indexWhere((n) => n.id == noticeId);
    if (index == -1 || _notices[index].isRead) return;
    _notices[index] = _notices[index].copyWith(isRead: true);
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
        title: 'Mudança no horário da viagem da manhã',
        message: 'A partir de segunda-feira o ônibus sairá 10 minutos mais cedo.',
        date: now.subtract(const Duration(days: 1, hours: 5)),
        category: NoticeCategory.transporte,
        isRead: false,
      ),
      Notice(
        id: 'n2',
        title: 'Nova vaga de contrapartida disponível',
        message: 'Limpeza do Ginásio em breve. Inscrições abertas!',
        date: now.subtract(const Duration(days: 1, hours: 7)),
        category: NoticeCategory.contrapartidas,
        isRead: false,
      ),
      Notice(
        id: 'n3',
        title: 'Semana Acadêmica 2026',
        message: 'Confira a programação completa da Semana Acadêmica.',
        date: now.subtract(const Duration(days: 8)),
        category: NoticeCategory.eventos,
        isRead: true,
      ),
      Notice(
        id: 'n4',
        title: 'Atenção, passageiros!',
        message: 'Cheguem com 5 minutos de antecedência no ponto de saída.',
        date: now.subtract(const Duration(days: 8, hours: 10)),
        category: NoticeCategory.urgente,
        isRead: false,
      ),
    ]);

    _counterpartDeadline = DateTime(now.year, 12, 31);
    _counterpartActivities.addAll([
      CounterpartActivity(
        id: 'c1',
        title: 'Limpeza do Ginásio',
        description: 'Organização e limpeza geral do ginásio de esportes antes do evento municipal.',
        location: 'Ginásio de Esportes',
        date: now.add(const Duration(days: 9)),
        startTime: '13:00',
        endTime: '16:00',
        responsible: 'Coordenação de Extensão',
        hours: 3,
        totalSlots: 15,
        takenSlots: 12,
      ),
      CounterpartActivity(
        id: 'c2',
        title: 'Organização da Feira',
        description: 'Montagem de estandes e apoio geral durante a feira de profissões.',
        location: 'Campus II',
        date: now.add(const Duration(days: 14)),
        startTime: '08:00',
        endTime: '13:00',
        responsible: 'Coordenação de Extensão',
        hours: 5,
        totalSlots: 10,
        takenSlots: 3,
      ),
      CounterpartActivity(
        id: 'c3',
        title: 'Apoio ao Evento Esportivo',
        description: 'Apoio na organização e recepção de participantes do evento esportivo.',
        location: 'Auditório Central',
        date: now.add(const Duration(days: 22)),
        startTime: '17:00',
        endTime: '21:00',
        responsible: 'Coordenação de Esportes',
        hours: 4,
        totalSlots: 8,
        takenSlots: 3,
      ),
      CounterpartActivity(
        id: 'c4',
        title: 'Biblioteca – Organização',
        description: 'Organização e catalogação de acervo na biblioteca central.',
        location: 'Biblioteca Central',
        date: now.add(const Duration(days: 30)),
        startTime: '14:00',
        endTime: '17:00',
        responsible: 'Coordenação de Extensão',
        hours: 6,
        totalSlots: 6,
        takenSlots: 2,
      ),
      CounterpartActivity(
        id: 'c5',
        title: 'Mutirão de Arrecadação',
        description: 'Apoio na triagem e organização de doações do mutirão comunitário.',
        location: 'Centro Comunitário',
        date: now.subtract(const Duration(days: 12)),
        startTime: '09:00',
        endTime: '12:00',
        responsible: 'Coordenação de Extensão',
        hours: 3,
        totalSlots: 12,
        takenSlots: 12,
        enrolled: true,
        completed: true,
      ),
      CounterpartActivity(
        id: 'c6',
        title: 'Apoio à Semana Acadêmica',
        description: 'Recepção e apoio geral aos participantes da Semana Acadêmica.',
        location: 'Campus I',
        date: now.subtract(const Duration(days: 6)),
        startTime: '13:00',
        endTime: '18:00',
        responsible: 'Coordenação de Extensão',
        hours: 5,
        totalSlots: 20,
        takenSlots: 20,
        enrolled: true,
        completed: true,
      ),
      CounterpartActivity(
        id: 'c7',
        title: 'Reforma da Horta Comunitária',
        description: 'Plantio e manutenção da horta comunitária do bairro.',
        location: 'Horta Comunitária',
        date: now.subtract(const Duration(days: 20)),
        startTime: '08:00',
        endTime: '18:10',
        responsible: 'Coordenação de Extensão',
        hours: 10,
        totalSlots: 10,
        takenSlots: 10,
        enrolled: true,
        completed: true,
      ),
    ]);
  }
}
