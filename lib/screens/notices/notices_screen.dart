import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/notice.dart';
import '../../state/app_data_provider.dart';
import '../../theme/app_theme.dart';

class NoticesScreen extends StatelessWidget {
  const NoticesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notices = context.watch<AppDataProvider>().notices;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
        title: const Text('Avisos'),
      ),
      body: SafeArea(
        child: notices.isEmpty
            ? const Center(child: Text('Nenhum aviso por enquanto.', style: TextStyle(color: AppColors.textSecondary)))
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                itemCount: notices.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) => _NoticeCard(notice: notices[index]),
              ),
      ),
    );
  }
}

class _NoticeCard extends StatelessWidget {
  const _NoticeCard({required this.notice});

  final Notice notice;

  ({IconData icon, Color color, Color bg}) get _style {
    switch (notice.type) {
      case NoticeType.info:
        return (icon: Icons.build_outlined, color: AppColors.primary, bg: AppColors.primary.withValues(alpha: 0.1));
      case NoticeType.warning:
        return (icon: Icons.warning_amber_rounded, color: AppColors.warning, bg: AppColors.warningBg);
      case NoticeType.success:
        return (icon: Icons.check_circle_outline, color: AppColors.success, bg: AppColors.successBg);
    }
  }

  String _formatDateTime(DateTime date) {
    final d = '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    final t = '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    return '$d - $t';
  }

  @override
  Widget build(BuildContext context) {
    final style = _style;
    return Card(
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
    );
  }
}
