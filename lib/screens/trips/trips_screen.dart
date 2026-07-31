import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/trip.dart';
import '../../state/app_data_provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/date_format.dart';
import '../../widgets/status_badge.dart';

class TripsScreen extends StatefulWidget {
  const TripsScreen({super.key});

  @override
  State<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(length: 2, vsync: this);

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<AppDataProvider>();

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Row(
              children: [
                const Text('Minhas viagens', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: AppColors.textSecondary,
              indicator: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
              dividerColor: Colors.transparent,
              tabs: const [Tab(text: 'Próximas'), Tab(text: 'Histórico')],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _TripsList(trips: data.upcomingTrips, showConfirm: true),
                _TripsList(trips: data.pastTrips, showConfirm: false),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TripsList extends StatelessWidget {
  const _TripsList({required this.trips, required this.showConfirm});

  final List<Trip> trips;
  final bool showConfirm;

  @override
  Widget build(BuildContext context) {
    if (trips.isEmpty) {
      return const Center(child: Text('Nenhuma viagem por aqui.', style: TextStyle(color: AppColors.textSecondary)));
    }

    final groups = <String, List<Trip>>{};
    for (final trip in trips) {
      final key = AppDateFormat.monthName(trip.date);
      groups.putIfAbsent(key, () => []).add(trip);
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        for (final entry in groups.entries) ...[
          Text(entry.key, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                for (var i = 0; i < entry.value.length; i++) ...[
                  _TripRow(trip: entry.value[i], showConfirm: showConfirm),
                  if (i != entry.value.length - 1) const Divider(height: 1, indent: 16, endIndent: 16),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ],
    );
  }
}

class _TripRow extends StatelessWidget {
  const _TripRow({required this.trip, required this.showConfirm});

  final Trip trip;
  final bool showConfirm;

  @override
  Widget build(BuildContext context) {
    final confirmed = trip.status == TripStatus.confirmed;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${AppDateFormat.weekdayAbbrevCapitalized(trip.date)}, ${AppDateFormat.dayMonth(trip.date)}',
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(trip.departureTime, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.5)),
              ],
            ),
          ),
          if (!showConfirm)
            const StatusBadge(label: 'Concluída', color: AppColors.textSecondary, background: Color(0xFFEDEEF2))
          else if (confirmed)
            const StatusBadge(label: 'Confirmado', color: AppColors.success, background: AppColors.successBg)
          else
            OutlinedButton(
              onPressed: () => context.read<AppDataProvider>().confirmPresence(trip.id),
              style: OutlinedButton.styleFrom(minimumSize: const Size(0, 36), padding: const EdgeInsets.symmetric(horizontal: 16)),
              child: const Text('Confirmar'),
            ),
        ],
      ),
    );
  }
}
