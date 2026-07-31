import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/confirm_presence/confirm_presence_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/notices/notices_screen.dart';
import '../screens/passengers/passengers_screen.dart';
import '../screens/profile/edit_profile_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/simple_info_screen.dart';
import '../screens/trips/trips_screen.dart';
import '../state/auth_provider.dart';
import '../widgets/main_scaffold.dart';

GoRouter buildRouter(AuthProvider authProvider) {
  return GoRouter(
    initialLocation: '/login',
    refreshListenable: authProvider,
    redirect: (context, state) {
      final loggedIn = authProvider.isAuthenticated;
      final onAuthPage = state.matchedLocation == '/login' || state.matchedLocation == '/register';

      if (!loggedIn && !onAuthPage) return '/login';
      if (loggedIn && onAuthPage) return '/';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
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
                  path: 'avisos',
                  builder: (context, state) => const NoticesScreen(),
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/viagens', builder: (context, state) => const TripsScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/passageiros', builder: (context, state) => const PassengersScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/perfil',
              builder: (context, state) => const ProfileScreen(),
              routes: [
                GoRoute(path: 'editar', builder: (context, state) => const EditProfileScreen()),
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
