import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/counterpart_activity.dart';
import '../../state/app_data_provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/date_format.dart';
import '../../widgets/status_badge.dart';

const _activityStyles = [
  (icon: Icons.cleaning_services_rounded, color: AppColors.success),
  (icon: Icons.storefront_rounded, color: AppColors.warning),
  (icon: Icons.groups_rounded, color: Color(0xFF8B5CF6)),
  (icon: Icons.menu_book_rounded, color: AppColors.primary),
];

({IconData icon, Color color}) _styleFor(int index) => _activityStyles[index % _activityStyles.length];

class CounterpartsScreen extends StatefulWidget {
  const CounterpartsScreen({super.key});

  @override
  State<CounterpartsScreen> createState() => _CounterpartsScreenState();
}

class _CounterpartsScreenState extends State<CounterpartsScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(length: 3, vsync: this);

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Text('Contrapartidas', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
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
              labelStyle: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
              tabs: const [Tab(text: 'Resumo'), Tab(text: 'Vagas disponíveis'), Tab(text: 'Meu histórico')],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [_ResumoTab(), _VagasTab(), _HistoricoTab()],
            ),
          ),
        ],
      ),
    );
  }
}

class _ResumoTab extends StatelessWidget {
  const _ResumoTab();

  @override
  Widget build(BuildContext context) {
    final data = context.watch<AppDataProvider>();
    final mine = data.myCounterpartActivities;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Resumo geral', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _StatColumn(
                        label: 'Horas obrigatórias',
                        value: '${data.counterpartRequiredHours}h',
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Expanded(
                      child: _StatColumn(
                        label: 'Horas concluídas',
                        value: '${data.counterpartCompletedHours}h',
                        color: AppColors.success,
                      ),
                    ),
                    Expanded(
                      child: _StatColumn(
                        label: 'Horas pendentes',
                        value: '${data.counterpartPendingHours}h',
                        color: AppColors.warning,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.event_outlined, color: AppColors.primary),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Prazo para conclusão', style: TextStyle(color: AppColors.textSecondary, fontSize: 12.5)),
                    Text(
                      '${AppDateFormat.dayMonth(data.counterpartDeadline)}/${data.counterpartDeadline.year}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (mine.isNotEmpty) ...[
          const SizedBox(height: 24),
          const Text('Minhas próximas atividades', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 10),
          Card(
            child: Column(
              children: [
                for (var i = 0; i < mine.length; i++) ...[
                  _MyActivityRow(activity: mine[i], style: _styleFor(i)),
                  if (i != mine.length - 1) const Divider(height: 1, indent: 16, endIndent: 16),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({required this.label, required this.value, required this.color});

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11.5)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 20)),
      ],
    );
  }
}

class _MyActivityRow extends StatelessWidget {
  const _MyActivityRow({required this.activity, required this.style});

  final CounterpartActivity activity;
  final ({IconData icon, Color color}) style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(color: style.color.withValues(alpha: 0.12), shape: BoxShape.circle),
            child: Icon(style.icon, color: style.color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(activity.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(
                  '${AppDateFormat.dayMonth(activity.date)} • ${activity.hours} horas',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.5),
                ),
              ],
            ),
          ),
          const StatusBadge(label: 'Inscrito', color: AppColors.success, background: AppColors.successBg),
        ],
      ),
    );
  }
}

class _VagasTab extends StatelessWidget {
  const _VagasTab();

  @override
  Widget build(BuildContext context) {
    final activities = context.watch<AppDataProvider>().availableCounterpartActivities;

    if (activities.isEmpty) {
      return const Center(child: Text('Nenhuma vaga disponível no momento.', style: TextStyle(color: AppColors.textSecondary)));
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      itemCount: activities.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, index) => _VagaCard(activity: activities[index], style: _styleFor(index)),
    );
  }
}

class _VagaCard extends StatelessWidget {
  const _VagaCard({required this.activity, required this.style});

  final CounterpartActivity activity;
  final ({IconData icon, Color color}) style;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(color: style.color.withValues(alpha: 0.12), shape: BoxShape.circle),
                  child: Icon(style.icon, color: style.color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(activity.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15.5)),
                ),
                StatusBadge(label: '${activity.hours} horas', color: AppColors.textSecondary, background: const Color(0xFFEDEEF2)),
              ],
            ),
            const SizedBox(height: 12),
            _InfoLine(
              icon: Icons.event_outlined,
              text: '${AppDateFormat.dayMonth(activity.date)}/${activity.date.year} • ${activity.startTime} às ${activity.endTime}',
            ),
            const SizedBox(height: 6),
            _InfoLine(icon: Icons.location_on_outlined, text: activity.location),
            const SizedBox(height: 6),
            _InfoLine(icon: Icons.confirmation_number_outlined, text: '${activity.slotsAvailable} vagas disponíveis'),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: activity.slotsAvailable <= 0
                    ? null
                    : () => context.read<AppDataProvider>().enrollInCounterpart(activity.id),
                child: Text(activity.slotsAvailable <= 0 ? 'Vagas esgotadas' : 'Inscrever-se'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13))),
      ],
    );
  }
}

class _HistoricoTab extends StatelessWidget {
  const _HistoricoTab();

  @override
  Widget build(BuildContext context) {
    final history = context.watch<AppDataProvider>().counterpartHistory;

    if (history.isEmpty) {
      return const Center(child: Text('Nenhuma atividade concluída ainda.', style: TextStyle(color: AppColors.textSecondary)));
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      itemCount: history.length,
      separatorBuilder: (_, __) => const SizedBox(height: 4),
      itemBuilder: (context, index) => Card(
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: AppColors.successBg, borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.check_circle_outline, color: AppColors.success),
          ),
          title: Text(history[index].title, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(
            'Concluído em ${AppDateFormat.dayMonth(history[index].date)}/${history[index].date.year}',
            style: const TextStyle(fontSize: 12.5),
          ),
          trailing: StatusBadge(label: '+${history[index].hours}h', color: AppColors.success, background: AppColors.successBg),
        ),
      ),
    );
  }
}
