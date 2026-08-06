import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/admin_models.dart';
import '../../models/notice.dart';
import '../../state/admin_data_provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/date_format.dart';

const _counterpartColors = [AppColors.success, AppColors.warning, AppColors.accentPurple, AppColors.primary];

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<AdminDataProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              SizedBox(
                width: 210,
                child: _StatCard(
                  icon: Icons.groups_rounded,
                  color: AppColors.primary,
                  value: '${data.studentsCount}',
                  label: 'Alunos cadastrados',
                  delta: '+${data.studentsNewThisMonth} este mês',
                  deltaColor: AppColors.success,
                ),
              ),
              SizedBox(
                width: 210,
                child: _StatCard(
                  icon: Icons.event_available_rounded,
                  color: AppColors.success,
                  value: '${data.tripsThisMonth}',
                  label: 'Viagens (mês)',
                  delta: '+${data.tripsDeltaVsLastMonth} em relação ao anterior',
                  deltaColor: AppColors.success,
                ),
              ),
              SizedBox(
                width: 210,
                child: _StatCard(
                  icon: Icons.directions_bus_filled_rounded,
                  color: AppColors.accentPurple,
                  value: '${data.activeBuses}',
                  label: 'Ônibus ativos',
                  delta: 'Todos em operação',
                  deltaColor: AppColors.textSecondary,
                ),
              ),
              SizedBox(
                width: 210,
                child: _StatCard(
                  icon: Icons.volunteer_activism_rounded,
                  color: AppColors.warning,
                  value: '${data.openCounterparts}',
                  label: 'Contrapartidas abertas',
                  delta: '+${data.openCounterpartsToday} novas hoje',
                  deltaColor: AppColors.success,
                ),
              ),
              SizedBox(
                width: 210,
                child: _StatCard(
                  icon: Icons.warning_amber_rounded,
                  color: AppColors.danger,
                  value: '${data.pendingCount}',
                  label: 'Pendências',
                  delta: 'Ver detalhes',
                  deltaColor: AppColors.danger,
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Funcionalidade de exemplo.')),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _ResponsiveTwoColumn(
            left: _VisaoGeralCard(data: data),
            right: const _AcoesRapidasCard(),
          ),
          const SizedBox(height: 20),
          _ResponsiveTwoColumn(
            left: _ProximasViagensCard(trips: data.upcomingTrips),
            right: Column(
              children: [
                _ContrapartidasRecentesCard(items: data.recentCounterparts),
                const SizedBox(height: 20),
                _AvisosNaoLidosCard(items: data.unreadNotices),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _ResponsiveTwoColumn(
            leftFlex: 1,
            rightFlex: 1,
            left: _OcupacaoOnibusCard(buses: data.busOccupancy),
            right: _AlunosPorSituacaoCard(
              active: data.studentsActive,
              inactive: data.studentsInactive,
              blocked: data.studentsBlocked,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Text('© ${DateTime.now().year} UniBus. Todos os direitos reservados.',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              const Spacer(),
              const Text('Versão 1.0.0', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ResponsiveTwoColumn extends StatelessWidget {
  const _ResponsiveTwoColumn({required this.left, required this.right, this.leftFlex = 2, this.rightFlex = 1});

  final Widget left;
  final Widget right;
  final int leftFlex;
  final int rightFlex;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 900) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: leftFlex, child: left),
              const SizedBox(width: 20),
              Expanded(flex: rightFlex, child: right),
            ],
          );
        }
        return Column(children: [left, const SizedBox(height: 20), right]);
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
    required this.delta,
    required this.deltaColor,
    this.onTap,
  });

  final IconData icon;
  final Color color;
  final String value;
  final String label;
  final String delta;
  final Color deltaColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: color, size: 21),
              ),
              const SizedBox(height: 14),
              Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.5)),
              const SizedBox(height: 6),
              Text(delta, style: TextStyle(color: deltaColor, fontSize: 11.5, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

class _VisaoGeralCard extends StatelessWidget {
  const _VisaoGeralCard({required this.data});

  final AdminDataProvider data;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('Visão geral', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.5)),
                const Spacer(),
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Funcionalidade de exemplo.')),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(border: Border.all(color: const Color(0xFFE2E5EC)), borderRadius: BorderRadius.circular(8)),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Este mês', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500)),
                        SizedBox(width: 4),
                        Icon(Icons.expand_more, size: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 24,
              runSpacing: 20,
              children: [
                SizedBox(
                  width: 190,
                  child: _DonutStat(
                    title: 'Presenças',
                    percent: data.presencePercent,
                    color: AppColors.primary,
                    legend: [
                      ('Presentes', '${data.presentCount}', AppColors.primary),
                      ('Faltas', '${data.absentCount}', const Color(0xFFCBD0DC)),
                    ],
                  ),
                ),
                SizedBox(
                  width: 220,
                  child: _OccupancyLineChart(series: data.occupancySeries),
                ),
                SizedBox(
                  width: 190,
                  child: _DonutStat(
                    title: 'Horas de contrapartida',
                    percent: data.counterpartHoursPercent,
                    color: AppColors.success,
                    legend: [
                      ('Horas concluídas', '${data.counterpartHoursCompleted}h', AppColors.success),
                      ('Pendentes', '${data.counterpartHoursPending}h', const Color(0xFFCBD0DC)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DonutStat extends StatelessWidget {
  const _DonutStat({required this.title, required this.percent, required this.color, required this.legend});

  final String title;
  final int percent;
  final Color color;
  final List<(String, String, Color)> legend;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.5, fontWeight: FontWeight.w500)),
        const SizedBox(height: 12),
        SizedBox(
          height: 96,
          width: 96,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  sectionsSpace: 0,
                  centerSpaceRadius: 30,
                  startDegreeOffset: -90,
                  sections: [
                    PieChartSectionData(value: percent.toDouble(), color: color, radius: 15, showTitle: false),
                    PieChartSectionData(
                      value: (100 - percent).toDouble(),
                      color: const Color(0xFFEDEEF2),
                      radius: 15,
                      showTitle: false,
                    ),
                  ],
                ),
              ),
              Text('$percent%', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        for (final entry in legend)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                Container(width: 8, height: 8, decoration: BoxDecoration(color: entry.$3, shape: BoxShape.circle)),
                const SizedBox(width: 6),
                Text('${entry.$1} ', style: const TextStyle(color: AppColors.textSecondary, fontSize: 11.5)),
                Text(entry.$2, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11.5)),
              ],
            ),
          ),
      ],
    );
  }
}

class _OccupancyLineChart extends StatelessWidget {
  const _OccupancyLineChart({required this.series});

  final List<double> series;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Ocupação média dos ônibus', style: TextStyle(color: AppColors.textSecondary, fontSize: 12.5, fontWeight: FontWeight.w500)),
        const SizedBox(height: 12),
        SizedBox(
          height: 108,
          child: LineChart(
            LineChartData(
              minY: 0,
              maxY: 100,
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: const FlTitlesData(show: false),
              lineTouchData: const LineTouchData(enabled: false),
              lineBarsData: [
                LineChartBarData(
                  spots: [for (var i = 0; i < series.length; i++) FlSpot(i.toDouble(), series[i])],
                  isCurved: true,
                  color: AppColors.primary,
                  barWidth: 2.5,
                  dotData: const FlDotData(show: true),
                  belowBarData: BarAreaData(show: true, color: AppColors.primary.withValues(alpha: 0.08)),
                ),
              ],
            ),
          ),
        ),
        if (series.isNotEmpty)
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
              child: Text('${series.last.round()}%', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 11.5)),
            ),
          ),
      ],
    );
  }
}

class _AcoesRapidasCard extends StatelessWidget {
  const _AcoesRapidasCard();

  @override
  Widget build(BuildContext context) {
    final actions = [
      (icon: Icons.directions_bus_outlined, label: 'Nova viagem', color: AppColors.primary),
      (icon: Icons.volunteer_activism_outlined, label: 'Nova contrapartida', color: AppColors.success),
      (icon: Icons.person_add_alt_outlined, label: 'Cadastrar aluno', color: AppColors.accentPurple),
      (icon: Icons.campaign_outlined, label: 'Enviar aviso', color: AppColors.warning),
      (icon: Icons.fact_check_outlined, label: 'Relatório de presença', color: AppColors.primary),
      (icon: Icons.download_outlined, label: 'Exportar dados', color: AppColors.textSecondary),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Ações rápidas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.5)),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.5,
              children: [
                for (final action in actions)
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Funcionalidade de exemplo.')),
                    ),
                    child: Container(
                      decoration: BoxDecoration(border: Border.all(color: const Color(0xFFE2E5EC)), borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(action.icon, color: action.color, size: 22),
                          const SizedBox(height: 6),
                          Text(
                            action.label,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProximasViagensCard extends StatelessWidget {
  const _ProximasViagensCard({required this.trips});

  final List<AdminTripRow> trips;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Próximas viagens', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.5)),
            const SizedBox(height: 14),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: 760,
                child: Column(
                  children: [
                    const Row(
                      children: [
                        _Cell('Data', flex: 2, header: true),
                        _Cell('Rota', flex: 3, header: true),
                        _Cell('Destino', flex: 3, header: true),
                        _Cell('Ônibus', flex: 2, header: true),
                        _Cell('Confirmados', flex: 2, header: true),
                      ],
                    ),
                    const Divider(height: 18),
                    for (var i = 0; i < trips.length; i++) ...[
                      _TripTableRow(trip: trips[i]),
                      if (i != trips.length - 1) const Divider(height: 18),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: TextButton(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Funcionalidade de exemplo.')),
                ),
                child: const Text('Ver todas as viagens'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TripTableRow extends StatelessWidget {
  const _TripTableRow({required this.trip});

  final AdminTripRow trip;

  @override
  Widget build(BuildContext context) {
    final ratio = trip.capacity <= 0 ? 0.0 : trip.confirmed / trip.capacity;
    final color = ratio >= 0.8 ? AppColors.success : (ratio >= 0.5 ? AppColors.warning : AppColors.danger);
    return Row(
      children: [
        _Cell('${AppDateFormat.weekdayAbbrevCapitalized(trip.date)}, ${AppDateFormat.dayMonth(trip.date)} • ${trip.departureTime}', flex: 2),
        _Cell(trip.route, flex: 3),
        _Cell(trip.destination, flex: 3),
        _Cell(trip.busName, flex: 2),
        Expanded(
          flex: 2,
          child: Text('${trip.confirmed}/${trip.capacity}', style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12.5)),
        ),
      ],
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell(this.text, {required this.flex, this.header = false});

  final String text;
  final int flex;
  final bool header;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: header
            ? const TextStyle(color: AppColors.textSecondary, fontSize: 11.5, fontWeight: FontWeight.bold)
            : const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500),
      ),
    );
  }
}

class _ContrapartidasRecentesCard extends StatelessWidget {
  const _ContrapartidasRecentesCard({required this.items});

  final List<RecentCounterpart> items;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('Contrapartidas recentes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5)),
                const Spacer(),
                TextButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Funcionalidade de exemplo.')),
                  ),
                  style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 28)),
                  child: const Text('Ver todas', style: TextStyle(fontSize: 12.5)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            for (var i = 0; i < items.length; i++) ...[
              _CounterpartRow(item: items[i], color: _counterpartColors[i % _counterpartColors.length]),
              if (i != items.length - 1) const Divider(height: 14),
            ],
          ],
        ),
      ),
    );
  }
}

class _CounterpartRow extends StatelessWidget {
  const _CounterpartRow({required this.item, required this.color});

  final RecentCounterpart item;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.12), shape: BoxShape.circle),
            child: Icon(Icons.volunteer_activism_outlined, color: color, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12.5)),
                Text(
                  '${AppDateFormat.dayMonth(item.date)}/${item.date.year} • ${item.startTime} às ${item.endTime}',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${item.hours}h', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11.5)),
              Text('${item.enrolled}/${item.totalSlots} vagas', style: const TextStyle(color: AppColors.textSecondary, fontSize: 10.5)),
            ],
          ),
        ],
      ),
    );
  }
}

class _AvisosNaoLidosCard extends StatelessWidget {
  const _AvisosNaoLidosCard({required this.items});

  final List<AdminNoticeSummary> items;

  ({IconData icon, Color color, String label}) _styleFor(NoticeCategory category) {
    switch (category) {
      case NoticeCategory.transporte:
        return (icon: Icons.directions_bus_outlined, color: AppColors.primary, label: 'Transporte');
      case NoticeCategory.contrapartidas:
        return (icon: Icons.volunteer_activism_outlined, color: AppColors.success, label: 'Contrapartidas');
      case NoticeCategory.eventos:
        return (icon: Icons.diversity_3_outlined, color: AppColors.accentPurple, label: 'Eventos');
      case NoticeCategory.urgente:
        return (icon: Icons.warning_amber_rounded, color: AppColors.danger, label: 'Urgente');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('Avisos não lidos', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5)),
                const Spacer(),
                TextButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Funcionalidade de exemplo.')),
                  ),
                  style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 28)),
                  child: const Text('Ver todas', style: TextStyle(fontSize: 12.5)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            for (var i = 0; i < items.length; i++) ...[
              _NoticeSummaryRow(item: items[i], style: _styleFor(items[i].category)),
              if (i != items.length - 1) const Divider(height: 14),
            ],
          ],
        ),
      ),
    );
  }
}

class _NoticeSummaryRow extends StatelessWidget {
  const _NoticeSummaryRow({required this.item, required this.style});

  final AdminNoticeSummary item;
  final ({IconData icon, Color color, String label}) style;

  @override
  Widget build(BuildContext context) {
    final d = item.sentAt;
    final formatted =
        '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')} às ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(style.icon, color: style.color, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(style.label, style: TextStyle(color: style.color, fontWeight: FontWeight.bold, fontSize: 10.5)),
                Text(item.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12.5)),
                Text('Enviado em $formatted', style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Container(width: 8, height: 8, margin: const EdgeInsets.only(top: 4), decoration: const BoxDecoration(color: AppColors.danger, shape: BoxShape.circle)),
        ],
      ),
    );
  }
}

class _OcupacaoOnibusCard extends StatelessWidget {
  const _OcupacaoOnibusCard({required this.buses});

  final List<BusOccupancy> buses;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Ocupação dos ônibus (média)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.5)),
            const SizedBox(height: 16),
            for (final bus in buses) ...[
              _BusOccupancyRow(bus: bus),
              const SizedBox(height: 14),
            ],
          ],
        ),
      ),
    );
  }
}

class _BusOccupancyRow extends StatelessWidget {
  const _BusOccupancyRow({required this.bus});

  final BusOccupancy bus;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 70, child: Text(bus.name, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500))),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: bus.percent / 100,
              minHeight: 8,
              backgroundColor: const Color(0xFFEDEEF2),
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 34,
          child: Text('${bus.percent}%', textAlign: TextAlign.right, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}

class _AlunosPorSituacaoCard extends StatelessWidget {
  const _AlunosPorSituacaoCard({required this.active, required this.inactive, required this.blocked});

  final int active;
  final int inactive;
  final int blocked;

  @override
  Widget build(BuildContext context) {
    final total = active + inactive + blocked;
    final entries = [
      ('Ativos', (count: active, color: AppColors.success)),
      ('Inativos', (count: inactive, color: AppColors.warning)),
      ('Bloqueados', (count: blocked, color: AppColors.danger)),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Alunos por situação', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.5)),
            const SizedBox(height: 16),
            Row(
              children: [
                SizedBox(
                  width: 110,
                  height: 110,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 34,
                          sections: [
                            for (final entry in entries)
                              PieChartSectionData(value: entry.$2.count.toDouble(), color: entry.$2.color, radius: 17, showTitle: false),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('$total', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          const Text('Total', style: TextStyle(color: AppColors.textSecondary, fontSize: 10.5)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final entry in entries)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              Container(width: 10, height: 10, decoration: BoxDecoration(color: entry.$2.color, shape: BoxShape.circle)),
                              const SizedBox(width: 8),
                              Expanded(child: Text(entry.$1, style: const TextStyle(fontSize: 12.5))),
                              Text('${entry.$2.count}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5)),
                              const SizedBox(width: 6),
                              Text(
                                '(${total <= 0 ? 0 : (entry.$2.count / total * 100).toStringAsFixed(1)}%)',
                                style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
