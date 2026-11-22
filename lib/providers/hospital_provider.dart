import 'package:flutter/material.dart';
import '../data/models/hospital_model.dart';
import '../data/models/doctor_model.dart';
import '../data/mock/seed_data.dart';

class HospitalProvider extends ChangeNotifier {
  final List<HospitalModel> _hospitals = List.from(SeedData.punjabHospitals);
  final List<DoctorModel> _doctors = List.from(SeedData.punjabDoctors);

  String _searchQuery = '';
  String _selectedCategory = 'all'; // 'all', 'emergency', 'phc', 'govt'

  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;

  List<HospitalModel> get filteredHospitals {
    return _hospitals.where((hosp) {
      final matchesSearch = _searchQuery.isEmpty ||
          hosp.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          hosp.district.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          hosp.cityOrVillage.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          hosp.specialties.any((s) => s.toLowerCase().contains(_searchQuery.toLowerCase()));

      if (!matchesSearch) return false;

      switch (_selectedCategory) {
        case 'emergency':
          return hosp.is24x7Emergency;
        case 'phc':
          return hosp.category.contains('PHC') || hosp.category.contains('Community');
        case 'govt':
          return hosp.isGovernment;
        default:
          return true;
      }
    }).toList();
  }

  List<HospitalModel> get hospitals => List.unmodifiable(_hospitals);
  List<HospitalModel> get allHospitals => List.unmodifiable(_hospitals);
  List<DoctorModel> get doctors => List.unmodifiable(_doctors);

  List<DoctorModel> getDoctorsForHospital(String hospitalId) {
    return _doctors.where((d) => d.hospitalId == hospitalId).toList();
  }

  DoctorModel? getDoctorById(String doctorId) {
    return _doctors.firstWhere(
      (d) => d.id == doctorId,
      orElse: () => _doctors.first,
    );
  }

  HospitalModel? getHospitalById(String hospitalId) {
    return _hospitals.firstWhere(
      (h) => h.id == hospitalId,
      orElse: () => _hospitals.first,
    );
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategoryFilter(String category) {
    _selectedCategory = category;
    notifyListeners();
  }
}
