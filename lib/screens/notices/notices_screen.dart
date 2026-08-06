import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/notice.dart';
import '../../state/app_data_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/status_badge.dart';

class NoticesScreen extends StatefulWidget {
  const NoticesScreen({super.key});

  @override
  State<NoticesScreen> createState() => _NoticesScreenState();
}

class _NoticesScreenState extends State<NoticesScreen> {
  NoticeCategory? _filter;

  @override
  Widget build(BuildContext context) {
    final notices = context.watch<AppDataProvider>().notices;
    final filtered = _filter == null ? notices : notices.where((n) => n.category == _filter).toList();

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Text('Avisos', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _FilterChip(label: 'Todos', selected: _filter == null, onTap: () => setState(() => _filter = null)),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Transporte',
                  selected: _filter == NoticeCategory.transporte,
                  onTap: () => setState(() => _filter = NoticeCategory.transporte),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Contrapartidas',
                  selected: _filter == NoticeCategory.contrapartidas,
                  onTap: () => setState(() => _filter = NoticeCategory.contrapartidas),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Eventos',
                  selected: _filter == NoticeCategory.eventos,
                  onTap: () => setState(() => _filter = NoticeCategory.eventos),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Urgente',
                  selected: _filter == NoticeCategory.urgente,
                  onTap: () => setState(() => _filter = NoticeCategory.urgente),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text('Nenhum aviso por aqui.', style: TextStyle(color: AppColors.textSecondary)))
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) => _NoticeCard(notice: filtered[index]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? AppColors.primary : const Color(0xFFE2E5EC)),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(color: selected ? Colors.white : AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 13),
        ),
      ),
    );
  }
}

class _NoticeCard extends StatelessWidget {
  const _NoticeCard({required this.notice});

  final Notice notice;

  ({IconData icon, Color color, Color bg, String label}) get _style {
    switch (notice.category) {
      case NoticeCategory.transporte:
        return (icon: Icons.directions_bus_outlined, color: AppColors.primary, bg: AppColors.primary.withValues(alpha: 0.1), label: 'Transporte');
      case NoticeCategory.contrapartidas:
        return (icon: Icons.volunteer_activism_outlined, color: AppColors.success, bg: AppColors.successBg, label: 'Contrapartidas');
      case NoticeCategory.eventos:
        return (icon: Icons.diversity_3_outlined, color: const Color(0xFF8B5CF6), bg: const Color(0xFF8B5CF6).withValues(alpha: 0.1), label: 'Eventos');
      case NoticeCategory.urgente:
        return (icon: Icons.warning_amber_rounded, color: AppColors.danger, bg: AppColors.dangerBg, label: 'Urgente');
    }
  }

  String _formatDateTime(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final diff = today.difference(target).inDays;
    final t = '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    if (diff == 0) return 'Hoje • $t';
    if (diff == 1) return 'Ontem • $t';
    final d = '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
    return '$d • $t';
  }

  @override
  Widget build(BuildContext context) {
    final style = _style;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => context.read<AppDataProvider>().markNoticeRead(notice.id),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: style.bg, borderRadius: BorderRadius.circular(10)),
                child: Icon(style.icon, color: style.color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        StatusBadge(label: style.label, color: style.color, background: style.bg),
                        if (!notice.isRead) ...[
                          const SizedBox(width: 6),
                          const StatusBadge(label: 'Novo', color: AppColors.danger, background: AppColors.dangerBg),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(notice.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    Text(_formatDateTime(notice.date), style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    const SizedBox(height: 8),
                    Text(notice.message, style: const TextStyle(color: AppColors.textPrimary, height: 1.3)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
