import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/notice.dart';
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
    final unreadNotices = data.notices.where((n) => !n.isRead).take(2).toList();

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
              Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    onPressed: () => context.go('/avisos'),
                    icon: const Icon(Icons.notifications_none_rounded, size: 28),
                  ),
                  if (data.unreadNoticesCount > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(color: AppColors.danger, shape: BoxShape.circle),
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (nextTrip != null) _NextTripCard(trip: nextTrip),
          const SizedBox(height: 20),
          const _QuickActions(),
          const SizedBox(height: 24),
          const _CounterpartsSummaryCard(),
          if (unreadNotices.isNotEmpty) ...[
            const SizedBox(height: 24),
            _UnreadNoticesSection(notices: unreadNotices, unreadCount: data.unreadNoticesCount),
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
                const Text('Próxima viagem', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
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

class _CounterpartsSummaryCard extends StatelessWidget {
  const _CounterpartsSummaryCard();

  @override
  Widget build(BuildContext context) {
    final data = context.watch<AppDataProvider>();
    final required = data.counterpartRequiredHours;
    final completed = data.counterpartCompletedHours;
    final pending = data.counterpartPendingHours;
    final next = data.nextCounterpartActivity;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('Contrapartidas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const Spacer(),
                TextButton(
                  onPressed: () => context.go('/contrapartidas'),
                  style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 32)),
                  child: const Text('Ver mais'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _HoursProgress(
                    label: 'Horas concluídas',
                    value: completed,
                    total: required,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _HoursProgress(
                    label: 'Horas pendentes',
                    value: pending,
                    total: required,
                    color: AppColors.warning,
                  ),
                ),
              ],
            ),
            if (next != null) ...[
              const SizedBox(height: 18),
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => context.go('/contrapartidas'),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.volunteer_activism_outlined, color: AppColors.primary, size: 18),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Próxima atividade', style: TextStyle(color: AppColors.textSecondary, fontSize: 11.5)),
                            Text(
                              '${next.title} • ${AppDateFormat.dayMonth(next.date)} • ${next.hours} horas',
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _HoursProgress extends StatelessWidget {
  const _HoursProgress({required this.label, required this.value, required this.total, required this.color});

  final String label;
  final int value;
  final int total;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final fraction = total <= 0 ? 0.0 : (value / total).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11.5)),
        const SizedBox(height: 4),
        Text('${value}h', style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 20)),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: fraction,
            minHeight: 6,
            backgroundColor: const Color(0xFFEDEEF2),
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }
}

class _UnreadNoticesSection extends StatelessWidget {
  const _UnreadNoticesSection({required this.notices, required this.unreadCount});

  final List<Notice> notices;
  final int unreadCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('Avisos não lidos', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            StatusBadge(label: '$unreadCount', color: AppColors.danger, background: AppColors.dangerBg),
            const Spacer(),
            TextButton(
              onPressed: () => context.go('/avisos'),
              style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 32)),
              child: const Text('Ver mais'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: [
              for (var i = 0; i < notices.length; i++) ...[
                _UnreadNoticeRow(notice: notices[i]),
                if (i != notices.length - 1) const Divider(height: 1, indent: 16, endIndent: 16),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _UnreadNoticeRow extends StatelessWidget {
  const _UnreadNoticeRow({required this.notice});

  final Notice notice;

  String get _categoryLabel {
    switch (notice.category) {
      case NoticeCategory.transporte:
        return 'Transporte';
      case NoticeCategory.contrapartidas:
        return 'Contrapartidas';
      case NoticeCategory.eventos:
        return 'Eventos';
      case NoticeCategory.urgente:
        return 'Urgente';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go('/avisos'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StatusBadge(label: _categoryLabel, color: AppColors.primary, background: AppColors.primary.withValues(alpha: 0.1)),
                  const SizedBox(height: 6),
                  Text(notice.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
          ],
        ),
      ),
    );
  }
}
