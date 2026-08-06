import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../state/admin_data_provider.dart';
import '../state/auth_provider.dart';
import '../theme/app_theme.dart';

class _AdminNavItem {
  const _AdminNavItem(this.label, this.icon, this.path);

  final String label;
  final IconData icon;
  final String path;
}

const _adminManagementItems = [
  _AdminNavItem('Alunos', Icons.school_outlined, '/admin/alunos'),
  _AdminNavItem('Viagens', Icons.calendar_month_outlined, '/admin/viagens'),
  _AdminNavItem('Contrapartidas', Icons.volunteer_activism_outlined, '/admin/contrapartidas'),
  _AdminNavItem('Passageiros', Icons.groups_outlined, '/admin/passageiros'),
  _AdminNavItem('Ônibus', Icons.directions_bus_outlined, '/admin/onibus'),
  _AdminNavItem('Motoristas', Icons.badge_outlined, '/admin/motoristas'),
];

const _adminCommunicationItems = [
  _AdminNavItem('Avisos', Icons.campaign_outlined, '/admin/avisos'),
  _AdminNavItem('Notificações', Icons.notifications_outlined, '/admin/notificacoes'),
];

const _adminReportItems = [
  _AdminNavItem('Relatórios', Icons.bar_chart_outlined, '/admin/relatorios'),
  _AdminNavItem('Exportações', Icons.file_download_outlined, '/admin/exportacoes'),
];

const _adminSettingsItems = [
  _AdminNavItem('Configurações', Icons.settings_outlined, '/admin/configuracoes'),
  _AdminNavItem('Parâmetros do sistema', Icons.tune_outlined, '/admin/parametros'),
  _AdminNavItem('Usuários', Icons.manage_accounts_outlined, '/admin/usuarios'),
];

/// Casca do Painel Administrativo: sidebar fixa em telas largas, drawer em
/// telas estreitas (mesmo conteúdo, mesma navegação por [GoRouter]).
class AdminScaffold extends StatelessWidget {
  const AdminScaffold({
    super.key,
    required this.currentPath,
    required this.child,
    required this.headerTitle,
    this.headerSubtitle,
  });

  final String currentPath;
  final Widget child;
  final String headerTitle;
  final String? headerSubtitle;

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width >= 1000;

    if (isDesktop) {
      return Scaffold(
        backgroundColor: AppColors.surface,
        body: Row(
          children: [
            SizedBox(
              width: 250,
              child: _AdminSidebar(currentPath: currentPath),
            ),
            Expanded(
              child: Column(
                children: [
                  _AdminTopBar(title: headerTitle, subtitle: headerSubtitle),
                  Expanded(child: child),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      drawer: Drawer(child: _AdminSidebar(currentPath: currentPath)),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Painel Administrativo'),
        actions: const [_AdminAvatarMenu(compact: true)],
      ),
      body: Column(
        children: [
          _AdminTopBar(title: headerTitle, subtitle: headerSubtitle, showSearch: false, showActions: false),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _AdminSidebar extends StatelessWidget {
  const _AdminSidebar({required this.currentPath});

  final String currentPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryDark,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.directions_bus_rounded, color: AppColors.primaryDark, size: 20),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('UniBus', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17)),
                        Text('Painel Administrativo', style: TextStyle(color: Colors.white70, fontSize: 11)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _AdminNavTile(
              item: const _AdminNavItem('Dashboard', Icons.dashboard_outlined, '/admin'),
              selected: currentPath == '/admin',
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 12),
                children: [
                  const _AdminSectionLabel('GERENCIAMENTO'),
                  for (final item in _adminManagementItems)
                    _AdminNavTile(item: item, selected: currentPath == item.path),
                  const _AdminSectionLabel('COMUNICAÇÃO'),
                  for (final item in _adminCommunicationItems)
                    _AdminNavTile(item: item, selected: currentPath == item.path),
                  const _AdminSectionLabel('RELATÓRIOS'),
                  for (final item in _adminReportItems)
                    _AdminNavTile(item: item, selected: currentPath == item.path),
                  const _AdminSectionLabel('CONFIGURAÇÕES'),
                  for (final item in _adminSettingsItems)
                    _AdminNavTile(item: item, selected: currentPath == item.path),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(14)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.headset_mic_outlined, color: Colors.white, size: 18),
                        SizedBox(width: 8),
                        Text('Suporte UniBus', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text('Precisando de ajuda?', style: TextStyle(color: Colors.white70, fontSize: 11.5)),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => _showComingSoon(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white38),
                          minimumSize: const Size(0, 36),
                        ),
                        child: const Text('Falar com suporte', style: TextStyle(fontSize: 12.5)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _showComingSoon(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Funcionalidade de exemplo.')),
  );
}

class _AdminSectionLabel extends StatelessWidget {
  const _AdminSectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.6),
      ),
    );
  }
}

class _AdminNavTile extends StatelessWidget {
  const _AdminNavTile({required this.item, required this.selected});

  final _AdminNavItem item;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: selected ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => context.go(item.path),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            child: Row(
              children: [
                Icon(item.icon, color: selected ? Colors.white : Colors.white70, size: 19),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.label,
                    style: TextStyle(
                      color: selected ? Colors.white : Colors.white70,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                      fontSize: 13.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AdminTopBar extends StatelessWidget {
  const _AdminTopBar({required this.title, this.subtitle, this.showSearch = true, this.showActions = true});

  final String title;
  final String? subtitle;
  final bool showSearch;
  final bool showActions;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 18),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE2E5EC))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(subtitle!, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.5)),
                ],
              ],
            ),
          ),
          if (showSearch) ...[
            const SizedBox(width: 20),
            const SizedBox(
              width: 280,
              child: TextField(
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'Buscar alunos, viagens, ônibus...',
                  hintStyle: TextStyle(fontSize: 12.5),
                  prefixIcon: Icon(Icons.search, size: 19),
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                ),
              ),
            ),
          ],
          if (showActions) ...[
            const SizedBox(width: 16),
            Consumer<AdminDataProvider>(
              builder: (context, data, _) => Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    onPressed: () => _showComingSoon(context),
                    icon: const Icon(Icons.notifications_none_rounded),
                  ),
                  if (data.unreadNotices.isNotEmpty)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(color: AppColors.danger, shape: BoxShape.circle),
                        constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                        child: Text(
                          '${data.unreadNotices.length}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const _AdminAvatarMenu(),
          ],
        ],
      ),
    );
  }
}

class _AdminAvatarMenu extends StatelessWidget {
  const _AdminAvatarMenu({this.compact = false});

  final bool compact;

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair da conta'),
        content: const Text('Tem certeza que deseja sair do painel administrativo?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sair', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context.read<AuthProvider>().logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'logout') _confirmLogout(context);
      },
      itemBuilder: (context) => const [
        PopupMenuItem(value: 'logout', child: Text('Sair')),
      ],
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(
            radius: 17,
            backgroundColor: AppColors.primary,
            child: Icon(Icons.person, color: Colors.white, size: 18),
          ),
          if (!compact) ...[
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user?.name ?? 'Administrador', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12.5)),
                Text(user?.email ?? '', style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
              ],
            ),
            const SizedBox(width: 4),
            const Icon(Icons.expand_more, size: 18, color: AppColors.textSecondary),
          ],
        ],
      ),
    );
  }
}
