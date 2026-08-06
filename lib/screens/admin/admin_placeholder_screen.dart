import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

/// Tela genérica para seções do Painel Administrativo ainda não
/// implementadas (Alunos, Ônibus, Motoristas, Relatórios etc.).
class AdminPlaceholderScreen extends StatelessWidget {
  const AdminPlaceholderScreen({super.key, required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                child: Icon(icon, size: 34, color: AppColors.primary),
              ),
              const SizedBox(height: 20),
              Text('$title em construção', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              const SizedBox(height: 8),
              const Text(
                'Esta seção ainda vai ganhar sua funcionalidade completa em uma próxima etapa do projeto.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary, height: 1.4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
