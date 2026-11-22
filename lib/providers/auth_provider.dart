import 'package:flutter/material.dart';
import '../data/models/user_model.dart';
import '../data/mock/seed_data.dart';
import '../core/services/local_storage_service.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;
  UserRole get currentRole => _currentUser?.role ?? UserRole.patient;

  AuthProvider() {
    _loadUser();
  }

  void _loadUser() {
    _currentUser = LocalStorageService.getUser() ?? SeedData.demoPatient;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));

    // Matching demo accounts or standard login
    if (email.contains('doctor')) {
      _currentUser = SeedData.demoDoctor;
    } else if (email.contains('admin')) {
      _currentUser = SeedData.demoAdmin;
    } else {
      _currentUser = SeedData.demoPatient.copyWith(email: email);
    }

    await LocalStorageService.saveUser(_currentUser!);
    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required UserRole role,
    required String password,
    String? specialization,
    String? qualifications,
    String? licenseNumber,
    String? bloodGroup,
    String? emergencyContact,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 700));

    _currentUser = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      phone: phone,
      role: role,
      bloodGroup: bloodGroup ?? 'B+',
      emergencyContact: emergencyContact ?? '+91 98765 00000',
      emergencyContactRelation: 'Family Member',
      specialization: specialization,
      qualifications: qualifications,
      licenseNumber: licenseNumber,
      hospitalAffiliation: 'Civil Hospital',
      experienceYears: role == UserRole.doctor ? 5 : null,
    );

    await LocalStorageService.saveUser(_currentUser!);
    _isLoading = false;
    notifyListeners();
    return true;
  }

  // Instant demo switcher for judges and testers
  Future<void> switchDemoRole(UserRole role) async {
    switch (role) {
      case UserRole.patient:
        _currentUser = SeedData.demoPatient;
        break;
      case UserRole.doctor:
        _currentUser = SeedData.demoDoctor;
        break;
      case UserRole.admin:
        _currentUser = SeedData.demoAdmin;
        break;
    }
    await LocalStorageService.saveUser(_currentUser!);
    notifyListeners();
  }

  Future<void> logout() async {
    await LocalStorageService.clearUser();
    _currentUser = null;
    notifyListeners();
  }

  Future<void> updateProfile(UserModel updatedUser) async {
    _currentUser = updatedUser;
    await LocalStorageService.saveUser(_currentUser!);
    notifyListeners();
  }
}
