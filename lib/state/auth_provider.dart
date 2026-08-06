import 'package:flutter/foundation.dart';

import '../models/app_user.dart';

const _adminEmail = 'adm@email.com';
const _adminPassword = 'adm123';

/// Gerencia sessão do usuário.
///
/// Hoje funciona com um usuário mock em memória. Quando o Firebase for
/// configurado (ver README), os métodos abaixo passam a chamar
/// FirebaseAuth em vez de simular localmente.
class AuthProvider extends ChangeNotifier {
  AppUser? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  AppUser? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> login({required String emailOrPhone, required String password}) async {
    _setLoading(true);
    await Future.delayed(const Duration(milliseconds: 600));

    if (emailOrPhone.trim().isEmpty || password.trim().isEmpty) {
      _errorMessage = 'Preencha e-mail/telefone e senha.';
      _setLoading(false);
      return false;
    }

    if (emailOrPhone.trim().toLowerCase() == _adminEmail && password == _adminPassword) {
      _currentUser = const AppUser(
        id: 'admin',
        name: 'Administrador',
        email: 'adm@email.com',
        phone: '',
        isAdmin: true,
      );
      _errorMessage = null;
      _setLoading(false);
      return true;
    }

    _currentUser = const AppUser(
      id: 'u1',
      name: 'Eduardo A. Giehl',
      email: 'eduardo@email.com',
      phone: '(49) 99999-9999',
      course: 'Ciência da Computação',
      semester: '5º Semestre',
      municipality: 'São Miguel do Oeste',
      boardingPoint: 'Em frente ao Mercado Central',
    );
    _errorMessage = null;
    _setLoading(false);
    return true;
  }

  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    _setLoading(true);
    await Future.delayed(const Duration(milliseconds: 600));

    if (name.trim().isEmpty || email.trim().isEmpty || password.trim().isEmpty) {
      _errorMessage = 'Preencha todos os campos obrigatórios.';
      _setLoading(false);
      return false;
    }

    _currentUser = AppUser(id: 'u1', name: name, email: email, phone: phone);
    _errorMessage = null;
    _setLoading(false);
    return true;
  }

  void updateProfile({String? name, String? email, String? phone}) {
    if (_currentUser == null) return;
    _currentUser = _currentUser!.copyWith(name: name, email: email, phone: phone);
    notifyListeners();
  }

  void setNotificationsEnabled(bool enabled) {
    if (_currentUser == null) return;
    _currentUser = _currentUser!.copyWith(notificationsEnabled: enabled);
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
