class HealthCampModel {
  final String id;
  final String title;
  final String village;
  final String district;
  final String state;
  final String date;
  final String time;
  final String venue;
  final String organizer;
  final List<String> services; // Eye checkup, Diabetes screening, Free medicine distribution
  final String contactPhone;
  final bool isFree;
  final String registrationStatus; // 'Open', 'Seats filling', 'Walk-in'
  final String imageUrl;

  HealthCampModel({
    required this.id,
    required this.title,
    required this.village,
    required this.district,
    this.state = 'Punjab',
    required this.date,
    required this.time,
    required this.venue,
    required this.organizer,
    required this.services,
    required this.contactPhone,
    this.isFree = true,
    this.registrationStatus = 'Walk-in Welcome',
    this.imageUrl = 'https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?w=600',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'village': village,
      'district': district,
      'state': state,
      'date': date,
      'time': time,
      'venue': venue,
      'organizer': organizer,
      'services': services,
      'contactPhone': contactPhone,
      'isFree': isFree,
      'registrationStatus': registrationStatus,
      'imageUrl': imageUrl,
    };
  }

  factory HealthCampModel.fromJson(Map<String, dynamic> json) {
    return HealthCampModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      village: json['village'] ?? '',
      district: json['district'] ?? '',
      state: json['state'] ?? 'Punjab',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      venue: json['venue'] ?? '',
      organizer: json['organizer'] ?? '',
      services: List<String>.from(json['services'] ?? []),
      contactPhone: json['contactPhone'] ?? '104',
      isFree: json['isFree'] ?? true,
      registrationStatus: json['registrationStatus'] ?? 'Walk-in Welcome',
      imageUrl: json['imageUrl'] ?? 'https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?w=600',
    );
  }
}

class GovernmentSchemeModel {
  final String id;
  final String titleEn;
  final String titleHi;
  final String titlePa;
  final String badge;
  final String descriptionEn;
  final String descriptionHi;
  final String descriptionPa;
  final String coverageAmount;
  final String eligibility;
  final List<String> requiredDocuments;
  final String portalUrl;
  final String helplineNumber;

  GovernmentSchemeModel({
    required this.id,
    required this.titleEn,
    required this.titleHi,
    required this.titlePa,
    required this.badge,
    required this.descriptionEn,
    required this.descriptionHi,
    required this.descriptionPa,
    required this.coverageAmount,
    required this.eligibility,
    required this.requiredDocuments,
    required this.portalUrl,
    required this.helplineNumber,
  });
}

class EmergencyFirstAidGuide {
  final String id;
  final String titleEn;
  final String titleHi;
  final String titlePa;
  final String icon;
  final List<String> stepsEn;
  final List<String> stepsHi;
  final List<String> stepsPa;
  final String doNotDoEn;
  final String doNotDoHi;
  final String doNotDoPa;
  final String emergencyDialNumber;

  EmergencyFirstAidGuide({
    required this.id,
    required this.titleEn,
    required this.titleHi,
    required this.titlePa,
    required this.icon,
    required this.stepsEn,
    required this.stepsHi,
    required this.stepsPa,
    required this.doNotDoEn,
    required this.doNotDoHi,
    required this.doNotDoPa,
    this.emergencyDialNumber = '108',
  });
}
