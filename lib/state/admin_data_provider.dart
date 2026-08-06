import 'package:flutter/foundation.dart';

import '../models/admin_models.dart';
import '../models/notice.dart';

/// Dados de exemplo do Painel Administrativo (dashboard, viagens, ônibus,
/// contrapartidas e avisos em nível de gestão).
///
/// Assim como o [AppDataProvider], hoje mantém tudo em memória. Quando o
/// Firestore for configurado, essas listas e contadores passam a vir de
/// consultas agregadas nas mesmas coleções usadas pelo app do aluno.
class AdminDataProvider extends ChangeNotifier {
  AdminDataProvider() {
    _seed();
  }

  int studentsCount = 0;
  int studentsNewThisMonth = 0;
  int tripsThisMonth = 0;
  int tripsDeltaVsLastMonth = 0;
  int activeBuses = 0;
  int openCounterparts = 0;
  int openCounterpartsToday = 0;
  int pendingCount = 0;

  int presentCount = 0;
  int absentCount = 0;

  int counterpartHoursCompleted = 0;
  int counterpartHoursPending = 0;

  int studentsActive = 0;
  int studentsInactive = 0;
  int studentsBlocked = 0;

  final List<double> occupancySeries = [];
  final List<AdminTripRow> upcomingTrips = [];
  final List<BusOccupancy> busOccupancy = [];
  final List<RecentCounterpart> recentCounterparts = [];
  final List<AdminNoticeSummary> unreadNotices = [];

  int get presencePercent {
    final total = presentCount + absentCount;
    return total <= 0 ? 0 : ((presentCount / total) * 100).round();
  }

  int get counterpartHoursPercent {
    final total = counterpartHoursCompleted + counterpartHoursPending;
    return total <= 0 ? 0 : ((counterpartHoursCompleted / total) * 100).round();
  }

  void _seed() {
    final now = DateTime.now();

    studentsCount = 245;
    studentsNewThisMonth = 12;
    tripsThisMonth = 18;
    tripsDeltaVsLastMonth = 3;
    activeBuses = 5;
    openCounterparts = 7;
    openCounterpartsToday = 2;
    pendingCount = 12;

    presentCount = 892;
    absentCount = 74;

    counterpartHoursCompleted = 280;
    counterpartHoursPending = 120;

    studentsActive = 220;
    studentsInactive = 15;
    studentsBlocked = 10;

    occupancySeries.addAll([60, 52, 58, 49, 68]);

    upcomingTrips.addAll([
      AdminTripRow(
        route: 'São Miguel → UNOESC',
        date: now.add(const Duration(days: 1)),
        departureTime: '06:30',
        destination: 'UNOESC – Campus I',
        busName: 'Ônibus 01',
        confirmed: 45,
        capacity: 50,
      ),
      AdminTripRow(
        route: 'Descanso → UNOESC',
        date: now.add(const Duration(days: 1)),
        departureTime: '07:00',
        destination: 'UNOESC – Campus I',
        busName: 'Ônibus 02',
        confirmed: 38,
        capacity: 45,
      ),
      AdminTripRow(
        route: 'Bandeirante → UNOESC',
        date: now.add(const Duration(days: 2)),
        departureTime: '06:30',
        destination: 'UNOESC – Campus I',
        busName: 'Ônibus 03',
        confirmed: 30,
        capacity: 45,
      ),
      AdminTripRow(
        route: 'Belmonte → UNOESC',
        date: now.add(const Duration(days: 2)),
        departureTime: '07:00',
        destination: 'UNOESC – Campus I',
        busName: 'Ônibus 04',
        confirmed: 25,
        capacity: 40,
      ),
      AdminTripRow(
        route: 'Guaraciaba → UNOESC',
        date: now.add(const Duration(days: 2)),
        departureTime: '06:40',
        destination: 'UNOESC – Campus I',
        busName: 'Ônibus 05',
        confirmed: 28,
        capacity: 45,
      ),
    ]);

    busOccupancy.addAll([
      const BusOccupancy(name: 'Ônibus 01', percent: 78),
      const BusOccupancy(name: 'Ônibus 02', percent: 65),
      const BusOccupancy(name: 'Ônibus 03', percent: 60),
      const BusOccupancy(name: 'Ônibus 04', percent: 55),
      const BusOccupancy(name: 'Ônibus 05', percent: 50),
    ]);

    recentCounterparts.addAll([
      RecentCounterpart(
        title: 'Limpeza do Ginásio',
        date: now.add(const Duration(days: 9)),
        startTime: '13:00',
        endTime: '16:00',
        hours: 3,
        totalSlots: 15,
        enrolled: 12,
      ),
      RecentCounterpart(
        title: 'Organização da Feira',
        date: now.add(const Duration(days: 14)),
        startTime: '08:00',
        endTime: '13:00',
        hours: 5,
        totalSlots: 10,
        enrolled: 7,
      ),
      RecentCounterpart(
        title: 'Apoio ao Evento Esportivo',
        date: now.add(const Duration(days: 22)),
        startTime: '17:00',
        endTime: '21:00',
        hours: 4,
        totalSlots: 8,
        enrolled: 5,
      ),
      RecentCounterpart(
        title: 'Biblioteca – Organização',
        date: now.add(const Duration(days: 30)),
        startTime: '14:00',
        endTime: '17:00',
        hours: 3,
        totalSlots: 6,
        enrolled: 2,
      ),
    ]);

    unreadNotices.addAll([
      AdminNoticeSummary(
        title: 'Mudança no horário da viagem da manhã',
        category: NoticeCategory.transporte,
        sentAt: now.subtract(const Duration(days: 1, hours: 5)),
      ),
      AdminNoticeSummary(
        title: 'Nova vaga de contrapartida disponível',
        category: NoticeCategory.contrapartidas,
        sentAt: now.subtract(const Duration(days: 1, hours: 7)),
      ),
      AdminNoticeSummary(
        title: 'Semana Acadêmica 2026',
        category: NoticeCategory.eventos,
        sentAt: now.subtract(const Duration(days: 1, hours: 9)),
      ),
    ]);
  }
}
