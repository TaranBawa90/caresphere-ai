class HospitalModel {
  final String id;
  final String name;
  final String category; // 'Civil Hospital', 'Rural PHC', 'Community Health Centre', 'Specialty'
  final String district;
  final String cityOrVillage;
  final String address;
  final String phone;
  final double latitude;
  final double longitude;
  final double distanceKm;
  final bool is24x7Emergency;
  final bool isGovernment;
  final bool isAyushmanEmpanelled;
  final int totalBeds;
  final int availableBeds;
  final double rating;
  final List<String> specialties;
  final String emergencyAmbulanceContact;
  final String imageUrl;

  HospitalModel({
    required this.id,
    required this.name,
    required this.category,
    required this.district,
    required this.cityOrVillage,
    required this.address,
    required this.phone,
    required this.latitude,
    required this.longitude,
    this.distanceKm = 2.4,
    required this.is24x7Emergency,
    required this.isGovernment,
    required this.isAyushmanEmpanelled,
    required this.totalBeds,
    required this.availableBeds,
    required this.rating,
    required this.specialties,
    this.emergencyAmbulanceContact = '108',
    this.imageUrl = 'https://images.unsplash.com/photo-1586773860418-d37222d8fce3?w=600',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'district': district,
      'cityOrVillage': cityOrVillage,
      'address': address,
      'phone': phone,
      'latitude': latitude,
      'longitude': longitude,
      'distanceKm': distanceKm,
      'is24x7Emergency': is24x7Emergency,
      'isGovernment': isGovernment,
      'isAyushmanEmpanelled': isAyushmanEmpanelled,
      'totalBeds': totalBeds,
      'availableBeds': availableBeds,
      'rating': rating,
      'specialties': specialties,
      'emergencyAmbulanceContact': emergencyAmbulanceContact,
      'imageUrl': imageUrl,
    };
  }

  factory HospitalModel.fromJson(Map<String, dynamic> json) {
    return HospitalModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      district: json['district'] ?? '',
      cityOrVillage: json['cityOrVillage'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 30.9010,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 75.8573,
      distanceKm: (json['distanceKm'] as num?)?.toDouble() ?? 3.5,
      is24x7Emergency: json['is24x7Emergency'] ?? false,
      isGovernment: json['isGovernment'] ?? true,
      isAyushmanEmpanelled: json['isAyushmanEmpanelled'] ?? true,
      totalBeds: json['totalBeds'] ?? 50,
      availableBeds: json['availableBeds'] ?? 12,
      rating: (json['rating'] as num?)?.toDouble() ?? 4.5,
      specialties: List<String>.from(json['specialties'] ?? []),
      emergencyAmbulanceContact: json['emergencyAmbulanceContact'] ?? '108',
      imageUrl: json['imageUrl'] ?? 'https://images.unsplash.com/photo-1586773860418-d37222d8fce3?w=600',
    );
  }
}
