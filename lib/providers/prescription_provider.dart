import 'package:flutter/material.dart';
import '../data/models/prescription_model.dart';
import '../data/mock/seed_data.dart';
import '../core/services/ocr_prescription_service.dart';
import '../core/services/local_storage_service.dart';

class PrescriptionProvider extends ChangeNotifier {
  final List<PrescriptionModel> _prescriptions = [];
  PrescriptionModel? _currentAnalysis;
  bool _isScanning = false;
  String _translationLanguage = 'en';

  List<PrescriptionModel> get prescriptions => List.unmodifiable(_prescriptions);
  PrescriptionModel? get currentAnalysis => _currentAnalysis;
  bool get isScanning => _isScanning;
  String get translationLanguage => _translationLanguage;

  PrescriptionProvider() {
    _loadPrescriptions();
  }

  void _loadPrescriptions() {
    final list = LocalStorageService.getPrescriptions();
    if (list.isNotEmpty) {
      _prescriptions.addAll(list);
    } else {
      _prescriptions.add(SeedData.samplePrescription);
    }
    _currentAnalysis = _prescriptions.firstOrNull;
    notifyListeners();
  }

  void setTranslationLanguage(String lang) {
    _translationLanguage = lang;
    notifyListeners();
  }

  Future<void> scanPrescription({String? imagePath, bool isDemo = false}) async {
    _isScanning = true;
    notifyListeners();

    final result = await OcrPrescriptionService.analyzePrescriptionImage(
      imagePath: imagePath,
      isDemoSample: isDemo,
    );

    _currentAnalysis = result;
    _isScanning = false;
    notifyListeners();
  }

  Future<void> saveCurrentPrescription() async {
    if (_currentAnalysis != null) {
      if (!_prescriptions.any((p) => p.id == _currentAnalysis!.id)) {
        _prescriptions.insert(0, _currentAnalysis!);
        await LocalStorageService.savePrescriptions(_prescriptions);
        notifyListeners();
      }
    }
  }

  void selectPrescription(PrescriptionModel rx) {
    _currentAnalysis = rx;
    notifyListeners();
  }
}
