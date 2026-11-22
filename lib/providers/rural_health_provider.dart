import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../data/models/rural_health_model.dart';
import '../data/mock/seed_data.dart';

class RuralHealthProvider extends ChangeNotifier {
  final List<HealthCampModel> _healthCamps = List.from(SeedData.punjabHealthCamps);
  final List<GovernmentSchemeModel> _schemes = List.from(SeedData.punjabGovernmentSchemes);
  final List<EmergencyFirstAidGuide> _firstAidGuides = List.from(SeedData.firstAidGuides);

  final _uuid = const Uuid();

  List<HealthCampModel> get healthCamps => List.unmodifiable(_healthCamps);
  List<GovernmentSchemeModel> get schemes => List.unmodifiable(_schemes);
  List<EmergencyFirstAidGuide> get firstAidGuides => List.unmodifiable(_firstAidGuides);

  void addHealthCamp({
    required String title,
    required String village,
    required String district,
    required String date,
    required String time,
    required String venue,
    required String organizer,
    required List<String> services,
    required String contactPhone,
  }) {
    final camp = HealthCampModel(
      id: 'camp_${_uuid.v4().substring(0, 8)}',
      title: title,
      village: village,
      district: district,
      date: date,
      time: time,
      venue: venue,
      organizer: organizer,
      services: services,
      contactPhone: contactPhone,
      isFree: true,
      registrationStatus: 'Walk-in Welcome',
    );
    _healthCamps.insert(0, camp);
    notifyListeners();
  }
}
