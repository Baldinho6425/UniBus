import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/trip.dart';
import '../../state/app_data_provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/date_format.dart';

class ConfirmPresenceScreen extends StatelessWidget {
  const ConfirmPresenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<AppDataProvider>();
    final trip = data.nextTrip;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
        title: const Text('Confirmar presença'),
      ),
      body: trip == null
          ? const Center(child: Text('Nenhuma viagem agendada.'))
          : SafeArea(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                children: [
                  _MonthStrip(trip: trip),
                  const SizedBox(height: 20),
                  Text(
                    '${AppDateFormat.weekdayLong(trip.date)}, ${trip.date.day} de ${AppDateFormat.monthName(trip.date).toLowerCase()}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 14),
                  _StatusBanner(confirmed: trip.status == TripStatus.confirmed),
                  const SizedBox(height: 18),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                      child: Column(
                        children: [
                          _DetailRow(icon: Icons.access_time, label: 'Horário de saída', value: trip.departureTime),
                          const Divider(height: 1),
                          _DetailRow(icon: Icons.location_on_outlined, label: 'Ponto de saída', value: trip.departurePoint),
                          const Divider(height: 1),
                          _DetailRow(icon: Icons.flag_outlined, label: 'Destino', value: trip.destination),
                          const Divider(height: 1),
                          _DetailRow(
                            icon: Icons.event_seat_outlined,
                            label: 'Vagas disponíveis',
                            value: '${trip.seatsAvailable} de ${trip.seatsTotal}',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (trip.status == TripStatus.confirmed) ...[
                    OutlinedButton(
                      onPressed: () => context.read<AppDataProvider>().cancelPresence(trip.id),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.danger,
                        side: const BorderSide(color: AppColors.danger),
                        minimumSize: const Size.fromHeight(52),
                      ),
                      child: const Text('Cancelar presença'),
                    ),
                    const SizedBox(height: 10),
                    const Center(
                      child: Text(
                        'Cancele até 20:00 do dia anterior.',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 12.5),
                      ),
                    ),
                  ] else
                    ElevatedButton(
                      onPressed: () => context.read<AppDataProvider>().confirmPresence(trip.id),
                      child: const Text('Confirmar presença'),
                    ),
                ],
              ),
            ),
    );
  }
}

class _MonthStrip extends StatelessWidget {
  const _MonthStrip({required this.trip});

  final Trip trip;

  @override
  Widget build(BuildContext context) {
    final days = List.generate(7, (i) => trip.date.add(Duration(days: i - trip.date.weekday % 7)));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(AppDateFormat.monthYear(trip.date), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (final day in days) _DayCell(day: day, isSelected: day.day == trip.date.day && day.month == trip.date.month),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({required this.day, required this.isSelected});

  final DateTime day;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          AppDateFormat.weekdayShort(day),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: day.weekday == DateTime.sunday ? AppColors.danger : AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Text(
            '${day.day}',
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.textPrimary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({required this.confirmed});

  final bool confirmed;

  @override
  Widget build(BuildContext context) {
    final color = confirmed ? AppColors.success : AppColors.warning;
    final bg = confirmed ? AppColors.successBg : AppColors.warningBg;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          Icon(confirmed ? Icons.check_circle : Icons.info_outline, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  confirmed ? 'Você está confirmado!' : 'Você ainda não confirmou',
                  style: TextStyle(color: color, fontWeight: FontWeight.bold),
                ),
                Text(
                  confirmed ? 'Sua presença para esta data já foi registrada.' : 'Confirme para garantir sua vaga nesta viagem.',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.5),
                ),
              ],
            ),
          ),
        ],
      ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600), textAlign: TextAlign.right),
        ],
      ),
    );
  }
}
