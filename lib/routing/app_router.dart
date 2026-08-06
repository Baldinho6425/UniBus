import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/admin/admin_dashboard_screen.dart';
import '../screens/admin/admin_placeholder_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/confirm_presence/confirm_presence_screen.dart';
import '../screens/counterparts/counterparts_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/notices/notices_screen.dart';
import '../screens/passengers/passengers_screen.dart';
import '../screens/profile/edit_profile_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/simple_info_screen.dart';
import '../screens/trips/trips_screen.dart';
import '../state/auth_provider.dart';
import '../widgets/admin_scaffold.dart';
import '../widgets/main_scaffold.dart';

GoRoute _adminPlaceholderRoute(String path, String title, IconData icon) {
  return GoRoute(
    path: path,
    builder: (context, state) => AdminScaffold(
      currentPath: path,
      headerTitle: title,
      headerSubtitle: 'Em construção',
      child: AdminPlaceholderScreen(title: title, icon: icon),
    ),
  );
}

GoRouter buildRouter(AuthProvider authProvider) {
  return GoRouter(
    initialLocation: '/login',
    refreshListenable: authProvider,
    redirect: (context, state) {
      final loggedIn = authProvider.isAuthenticated;
      final isAdmin = authProvider.currentUser?.isAdmin ?? false;
      final loc = state.matchedLocation;
      final onAuthPage = loc == '/login' || loc == '/register';
      final onAdminArea = loc.startsWith('/admin');

      if (!loggedIn && !onAuthPage) return '/login';
      if (loggedIn && onAuthPage) return isAdmin ? '/admin' : '/';
      if (loggedIn && isAdmin && !onAdminArea) return '/admin';
      if (loggedIn && !isAdmin && onAdminArea) return '/';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminScaffold(
          currentPath: '/admin',
          headerTitle: 'Olá, Administrador! 👋',
          headerSubtitle: 'Bem-vindo ao Painel do UniBus',
          child: AdminDashboardScreen(),
        ),
      ),
      _adminPlaceholderRoute('/admin/alunos', 'Alunos', Icons.school_outlined),
      _adminPlaceholderRoute('/admin/viagens', 'Viagens', Icons.calendar_month_outlined),
      _adminPlaceholderRoute('/admin/contrapartidas', 'Contrapartidas', Icons.volunteer_activism_outlined),
      _adminPlaceholderRoute('/admin/passageiros', 'Passageiros', Icons.groups_outlined),
      _adminPlaceholderRoute('/admin/onibus', 'Ônibus', Icons.directions_bus_outlined),
      _adminPlaceholderRoute('/admin/motoristas', 'Motoristas', Icons.badge_outlined),
      _adminPlaceholderRoute('/admin/avisos', 'Avisos', Icons.campaign_outlined),
      _adminPlaceholderRoute('/admin/notificacoes', 'Notificações', Icons.notifications_outlined),
      _adminPlaceholderRoute('/admin/relatorios', 'Relatórios', Icons.bar_chart_outlined),
      _adminPlaceholderRoute('/admin/exportacoes', 'Exportações', Icons.file_download_outlined),
      _adminPlaceholderRoute('/admin/configuracoes', 'Configurações', Icons.settings_outlined),
      _adminPlaceholderRoute('/admin/parametros', 'Parâmetros do sistema', Icons.tune_outlined),
      _adminPlaceholderRoute('/admin/usuarios', 'Usuários', Icons.manage_accounts_outlined),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => MainScaffold(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const HomeScreen(),
              routes: [
                GoRoute(
                  path: 'confirmar-presenca',
                  builder: (context, state) => const ConfirmPresenceScreen(),
                ),
                GoRoute(
                  path: 'passageiros',
                  builder: (context, state) => const PassengersScreen(),
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/viagens', builder: (context, state) => const TripsScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/contrapartidas', builder: (context, state) => const CounterpartsScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/avisos', builder: (context, state) => const NoticesScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/perfil',
              builder: (context, state) => const ProfileScreen(),
              routes: [
                GoRoute(path: 'editar', builder: (context, state) => const EditProfileScreen()),
                GoRoute(
                  path: 'documentos',
                  builder: (context, state) => const SimpleInfoScreen(
                    title: 'Documentos',
                    message: 'Em breve você poderá enviar e gerenciar seus documentos diretamente por aqui.',
                    icon: Icons.description_outlined,
                  ),
                ),
                GoRoute(
                  path: 'senha',
                  builder: (context, state) => const SimpleInfoScreen(
                    title: 'Alterar senha',
                    message: 'Em breve você poderá alterar sua senha diretamente por aqui.',
                    icon: Icons.lock_outline,
                  ),
                ),
                GoRoute(
                  path: 'ajuda',
                  builder: (context, state) => const SimpleInfoScreen(
                    title: 'Ajuda e suporte',
                    message: 'Precisa de ajuda? Fale com a organização do transporte pelo e-mail suporte@unibus.app.',
                    icon: Icons.help_outline,
                  ),
                ),
                GoRoute(
                  path: 'sobre',
                  builder: (context, state) => const SimpleInfoScreen(
                    title: 'Sobre o UniBus',
                    message: 'UniBus organiza sua rota até a faculdade: confirme presença, acompanhe viagens e '
                        'veja quem mais está indo com você. Versão 0.1.0.',
                    icon: Icons.info_outline,
                  ),
                ),
              ],
            ),
          ]),
        ],
      ),
    ],
  );
}
