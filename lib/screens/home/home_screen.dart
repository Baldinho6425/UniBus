import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/trip.dart';
import '../../state/app_data_provider.dart';
import '../../state/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/date_format.dart';
import '../../widgets/status_badge.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final data = context.watch<AppDataProvider>();
    final nextTrip = data.nextTrip;
    final firstName = (user?.name ?? '').split(' ').first;
    final upcomingPreview = data.upcomingTrips.skip(1).take(3).toList();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Olá, $firstName! 👋', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    Text(
                      '${AppDateFormat.weekdayLong(DateTime.now())}, ${AppDateFormat.dayMonth(DateTime.now())} de ${AppDateFormat.monthName(DateTime.now()).toLowerCase()}',
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => context.go('/avisos'),
                icon: const Icon(Icons.notifications_none_rounded, size: 28),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (nextTrip != null) _NextTripCard(trip: nextTrip),
          const SizedBox(height: 20),
          _QuickActions(),
          const SizedBox(height: 24),
          if (upcomingPreview.isNotEmpty) ...[
            const Text('Próximas viagens', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Card(
              child: Column(
                children: [
                  for (var i = 0; i < upcomingPreview.length; i++) ...[
                    _UpcomingTripRow(trip: upcomingPreview[i]),
                    if (i != upcomingPreview.length - 1) const Divider(height: 1, indent: 16, endIndent: 16),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _NextTripCard extends StatelessWidget {
  const _NextTripCard({required this.trip});

  final Trip trip;

  @override
  Widget build(BuildContext context) {
    final confirmed = trip.status == TripStatus.confirmed;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.directions_bus_rounded, size: 18, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Text('Próxima viagem', style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
                const Spacer(),
                StatusBadge(
                  label: confirmed ? 'Confirmado' : 'Pendente',
                  color: confirmed ? AppColors.success : AppColors.warning,
                  background: confirmed ? AppColors.successBg : AppColors.warningBg,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(AppDateFormat.relativeOrWeekday(trip.date), style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(trip.departureTime, style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      const Text('Ponto de saída', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                      Text(trip.departurePoint, style: const TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16)),
                  child: const Icon(Icons.directions_bus_filled_rounded, color: AppColors.primary, size: 34),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    final actions = [
      (icon: Icons.check_circle_outline, label: 'Confirmar\npresença', color: AppColors.success, route: '/confirmar-presenca'),
      (icon: Icons.calendar_month_outlined, label: 'Minhas\nviagens', color: AppColors.primary, route: '/viagens'),
      (icon: Icons.groups_outlined, label: 'Passageiros', color: const Color(0xFF8B5CF6), route: '/passageiros'),
      (icon: Icons.campaign_outlined, label: 'Avisos', color: AppColors.warning, route: '/avisos'),
    ];

    return Row(
      children: [
        for (final action in actions) ...[
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => context.go(action.route),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Column(
                    children: [
                      Icon(action.icon, color: action.color, size: 26),
                      const SizedBox(height: 8),
                      Text(
                        action.label,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (action != actions.last) const SizedBox(width: 10),
        ],
      ],
    );
  }
}

class _UpcomingTripRow extends StatelessWidget {
  const _UpcomingTripRow({required this.trip});

  final Trip trip;

  @override
  Widget build(BuildContext context) {
    final confirmed = trip.status == TripStatus.confirmed;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${AppDateFormat.weekdayAbbrevCapitalized(trip.date)}, ${AppDateFormat.dayMonth(trip.date)}',
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(trip.departureTime, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.5)),
              ],
            ),
          ),
          if (confirmed)
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
