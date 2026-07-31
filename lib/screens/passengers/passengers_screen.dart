import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/passenger.dart';
import '../../state/app_data_provider.dart';
import '../../theme/app_theme.dart';

class PassengersScreen extends StatefulWidget {
  const PassengersScreen({super.key});

  @override
  State<PassengersScreen> createState() => _PassengersScreenState();
}

class _PassengersScreenState extends State<PassengersScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  bool _onlyConfirmed = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final all = context.watch<AppDataProvider>().passengers;
    final confirmedCount = all.where((p) => p.confirmed).length;

    final filtered = all.where((p) {
      final matchesQuery = p.name.toLowerCase().contains(_query.toLowerCase());
      final matchesFilter = !_onlyConfirmed || p.confirmed;
      return matchesQuery && matchesFilter;
    }).toList();

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Text('Passageiros', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _query = v),
              decoration: const InputDecoration(
                hintText: 'Buscar passageiro...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Row(
              children: [
                _FilterChip(
                  label: 'Todos (${all.length})',
                  selected: !_onlyConfirmed,
                  onTap: () => setState(() => _onlyConfirmed = false),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Confirmados ($confirmedCount)',
                  selected: _onlyConfirmed,
                  onTap: () => setState(() => _onlyConfirmed = true),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text('Nenhum passageiro encontrado.', style: TextStyle(color: AppColors.textSecondary)))
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 4),
                    itemBuilder: (context, index) => _PassengerTile(passenger: filtered[index]),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Lista exportada (funcionalidade de exemplo).')),
                );
              },
              icon: const Icon(Icons.download_outlined),
              label: const Text('Exportar lista'),
              style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? AppColors.primary : const Color(0xFFE2E5EC)),
        ),
        child: Text(
          label,
          style: TextStyle(color: selected ? Colors.white : AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 13),
        ),
      ),
    );
  }
}

class _PassengerTile extends StatelessWidget {
  const _PassengerTile({required this.passenger});

  final Passenger passenger;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withValues(alpha: 0.12),
          child: Text(passenger.initials, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
        ),
        title: Text(passenger.name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: passenger.confirmed
            ? const Text('Confirmado', style: TextStyle(color: AppColors.success, fontSize: 12.5))
            : const Text('Aguardando confirmação', style: TextStyle(color: AppColors.warning, fontSize: 12.5)),
        trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      ),
    );
  }
}
