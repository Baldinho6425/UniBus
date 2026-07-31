import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../state/auth_provider.dart';
import '../../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair da conta'),
        content: const Text('Tem certeza que deseja sair?'),
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
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          const Text('Perfil', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          if (user != null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: AppColors.primary,
                      child: Text(user.initials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 2),
                          Text(user.email, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                          Text(user.phone, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 20),
          Card(
            child: Column(
              children: [
                _ProfileTile(
                  icon: Icons.edit_outlined,
                  label: 'Editar perfil',
                  onTap: () => context.push('/perfil/editar'),
                ),
                const Divider(height: 1, indent: 56),
                _ProfileTile(
                  icon: Icons.notifications_outlined,
                  label: 'Notificações',
                  trailing: Switch(
                    value: user?.notificationsEnabled ?? true,
                    onChanged: (v) => context.read<AuthProvider>().setNotificationsEnabled(v),
                  ),
                ),
                const Divider(height: 1, indent: 56),
                _ProfileTile(
                  icon: Icons.lock_outline,
                  label: 'Alterar senha',
                  onTap: () => context.push('/perfil/senha'),
                ),
                const Divider(height: 1, indent: 56),
                _ProfileTile(
                  icon: Icons.help_outline,
                  label: 'Ajuda e suporte',
                  onTap: () => context.push('/perfil/ajuda'),
                ),
                const Divider(height: 1, indent: 56),
                _ProfileTile(
                  icon: Icons.info_outline,
                  label: 'Sobre o UniBus',
                  onTap: () => context.push('/perfil/sobre'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton(
            onPressed: () => _confirmLogout(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.danger,
              side: const BorderSide(color: AppColors.danger),
            ),
            child: const Text('Sair da conta'),
          ),
        ],
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({required this.icon, required this.label, this.onTap, this.trailing});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textSecondary),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: trailing ?? (onTap != null ? const Icon(Icons.chevron_right, color: AppColors.textSecondary) : null),
      onTap: onTap,
    );
  }
}
