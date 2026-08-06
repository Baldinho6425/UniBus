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
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Row(
              children: [
                Text('Minhas viagens', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
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
                _UpcomingTripsList(trips: data.upcomingTrips),
                _HistoryTripsList(trips: data.pastTrips),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UpcomingTripsList extends StatelessWidget {
  const _UpcomingTripsList({required this.trips});

  final List<Trip> trips;

  @override
  Widget build(BuildContext context) {
    if (trips.isEmpty) {
      return const Center(child: Text('Nenhuma viagem por aqui.', style: TextStyle(color: AppColors.textSecondary)));
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        const Text('Próximas viagens', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
        const SizedBox(height: 10),
        for (final trip in trips) ...[
          _UpcomingTripCard(trip: trip),
          const SizedBox(height: 12),
        ],
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(12)),
          child: const Row(
            children: [
              Icon(Icons.info_outline, size: 18, color: AppColors.primary),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Os horários e pontos podem sofrer alterações. Fique atento aos avisos!',
                  style: TextStyle(color: AppColors.primary, fontSize: 12.5),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _UpcomingTripCard extends StatelessWidget {
  const _UpcomingTripCard({required this.trip});

  final Trip trip;

  void _showDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${AppDateFormat.weekdayLong(trip.date)}, ${AppDateFormat.dayMonth(trip.date)}',
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 14),
              _DetailRow(icon: Icons.access_time, label: 'Horário de saída', value: trip.departureTime),
              const Divider(height: 20),
              _DetailRow(icon: Icons.location_on_outlined, label: 'Ponto de saída', value: trip.departurePoint),
              const Divider(height: 20),
              _DetailRow(icon: Icons.flag_outlined, label: 'Destino', value: trip.destination),
              const Divider(height: 20),
              _DetailRow(icon: Icons.event_seat_outlined, label: 'Vagas disponíveis', value: '${trip.seatsAvailable} de ${trip.seatsTotal}'),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final confirmed = trip.status == TripStatus.confirmed;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${AppDateFormat.weekdayAbbrevCapitalized(trip.date)}, ${AppDateFormat.dayMonth(trip.date)} • ${trip.departureTime}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      if (confirmed)
                        const StatusBadge(label: 'Confirmado', color: AppColors.success, background: AppColors.successBg)
                      else
                        const StatusBadge(label: 'Pendente', color: AppColors.warning, background: AppColors.warningBg),
                    ],
                  ),
                ),
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.directions_bus_filled_rounded, color: AppColors.primary, size: 22),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _InfoLine(icon: Icons.location_on_outlined, label: 'Ponto de saída', value: trip.departurePoint),
            const SizedBox(height: 6),
            _InfoLine(icon: Icons.flag_outlined, label: 'Destino', value: trip.destination),
            const SizedBox(height: 14),
            if (confirmed)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.read<AppDataProvider>().cancelPresence(trip.id),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.danger,
                        side: const BorderSide(color: AppColors.danger),
                        minimumSize: const Size(0, 44),
                      ),
                      child: const Text('Cancelar presença'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _showDetails(context),
                      style: OutlinedButton.styleFrom(minimumSize: const Size(0, 44)),
                      child: const Text('Ver detalhes'),
                    ),
                  ),
                ],
              )
            else
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.read<AppDataProvider>().confirmPresence(trip.id),
                  child: const Text('Confirmar presença'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Text('$label: ', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.5)),
        Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12.5))),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.textSecondary),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(color: AppColors.textSecondary)),
        const Spacer(),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600), textAlign: TextAlign.right),
      ],
    );
  }
}

class _HistoryTripsList extends StatelessWidget {
  const _HistoryTripsList({required this.trips});

  final List<Trip> trips;

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
                  _HistoryTripRow(trip: entry.value[i]),
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

class _HistoryTripRow extends StatelessWidget {
  const _HistoryTripRow({required this.trip});

  final Trip trip;

  @override
  Widget build(BuildContext context) {
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
          const StatusBadge(label: 'Concluída', color: AppColors.textSecondary, background: Color(0xFFEDEEF2)),
        ],
      ),
    );
  }
}
