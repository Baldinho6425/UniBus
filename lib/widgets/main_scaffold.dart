import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_theme.dart';

const _destinations = [
  (icon: Icons.home_rounded, outlinedIcon: Icons.home_outlined, label: 'Início'),
  (icon: Icons.calendar_month_rounded, outlinedIcon: Icons.calendar_month_outlined, label: 'Viagens'),
  (icon: Icons.groups_rounded, outlinedIcon: Icons.groups_outlined, label: 'Passageiros'),
  (icon: Icons.person_rounded, outlinedIcon: Icons.person_outline, label: 'Perfil'),
];

/// Casca de navegação compartilhada entre mobile e desktop, usada como
/// `builder` de um [StatefulShellRoute.indexedStack].
///
/// Em telas estreitas usa uma barra de navegação inferior (como no mockup
/// mobile); em telas largas (desktop/tablet) troca para um NavigationRail
/// lateral, mantendo o mesmo conteúdo e destinos.
class MainScaffold extends StatelessWidget {
  const MainScaffold({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width >= 840;
    final currentIndex = navigationShell.currentIndex;
    void onSelect(int index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        );

    if (isDesktop) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: currentIndex,
              onDestinationSelected: onSelect,
              backgroundColor: Colors.white,
              labelType: NavigationRailLabelType.all,
              leading: const Padding(
                padding: EdgeInsets.only(bottom: 24, top: 8),
                child: _BrandMark(),
              ),
              destinations: [
                for (final d in _destinations)
                  NavigationRailDestination(icon: Icon(d.outlinedIcon), selectedIcon: Icon(d.icon), label: Text(d.label)),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: navigationShell,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onSelect,
        destinations: [
          for (final d in _destinations)
            NavigationDestination(icon: Icon(d.outlinedIcon), selectedIcon: Icon(d.icon), label: d.label),
        ],
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      radius: 20,
      backgroundColor: AppColors.primary,
      child: Icon(Icons.directions_bus_rounded, color: Colors.white, size: 22),
    );
  }
}
