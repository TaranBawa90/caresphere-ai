import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../data/models/health_record_model.dart';
import '../data/mock/seed_data.dart';
import '../core/services/local_storage_service.dart';

class HealthRecordsProvider extends ChangeNotifier {
  final List<HealthRecordModel> _records = [];
  final _uuid = const Uuid();

  List<HealthRecordModel> get records => List.unmodifiable(_records);

  HealthRecordsProvider() {
    _loadRecords();
  }

  void _loadRecords() {
    final list = LocalStorageService.getHealthRecords();
    if (list.isNotEmpty) {
      _records.addAll(list);
    } else {
      _records.addAll(SeedData.sampleHealthRecords);
    }
    notifyListeners();
  }

  Future<void> addRecord(HealthRecordModel record) async {
    _records.insert(0, record);
    await LocalStorageService.saveHealthRecords(_records);
    notifyListeners();
  }

  Future<void> deleteRecord(String recordId) async {
    _records.removeWhere((r) => r.id == recordId);
    await LocalStorageService.saveHealthRecords(_records);
    notifyListeners();
  }

  HealthRecordModel? get latestVitals {
    return _records.firstWhere(
      (r) => r.recordType == RecordType.vitals,
      orElse: () => _records.first,
    );
  }

  Future<void> recordQuickVitals({
    required String patientId,
    required int systolic,
    required int diastolic,
    required int bloodSugar,
    required int heartRate,
    required int spO2,
    double? weight,
  }) async {
    final record = HealthRecordModel(
      id: 'rec_${_uuid.v4().substring(0, 8)}',
      patientId: patientId,
      title: 'Health Vitals Log',
      recordType: RecordType.vitals,
      date: DateTime.now(),
      systolicBP: systolic,
      diastolicBP: diastolic,
      bloodSugarFasting: bloodSugar,
      heartRate: heartRate,
      spO2: spO2,
      weightKg: weight,
      notes: 'Recorded via CareSphere health monitor',
    );
    await addRecord(record);
  }
}
