class DoctorModel {
  final String id;
  final String name;
  final String specialty;
  final String qualification;
  final int experienceYears;
  final String hospitalId;
  final String hospitalName;
  final double fee; // 0 for Govt PHC/Civil hospital
  final double rating;
  final int reviewsCount;
  final List<String> languages; // 'English', 'Hindi', 'Punjabi'
  final List<String> availableDays;
  final List<String> timeSlots;
  final String avatarUrl;
  final bool isOnlineConsultAvailable;
  final String about;

  DoctorModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.qualification,
    required this.experienceYears,
    required this.hospitalId,
    required this.hospitalName,
    required this.fee,
    required this.rating,
    required this.reviewsCount,
    required this.languages,
    required this.availableDays,
    required this.timeSlots,
    required this.avatarUrl,
    required this.isOnlineConsultAvailable,
    required this.about,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialty': specialty,
      'qualification': qualification,
      'experienceYears': experienceYears,
      'hospitalId': hospitalId,
      'hospitalName': hospitalName,
      'fee': fee,
      'rating': rating,
      'reviewsCount': reviewsCount,
      'languages': languages,
      'availableDays': availableDays,
      'timeSlots': timeSlots,
      'avatarUrl': avatarUrl,
      'isOnlineConsultAvailable': isOnlineConsultAvailable,
      'about': about,
    };
  }

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      specialty: json['specialty'] ?? '',
      qualification: json['qualification'] ?? '',
      experienceYears: json['experienceYears'] ?? 5,
      hospitalId: json['hospitalId'] ?? '',
      hospitalName: json['hospitalName'] ?? '',
      fee: (json['fee'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 4.8,
      reviewsCount: json['reviewsCount'] ?? 120,
      languages: List<String>.from(json['languages'] ?? ['English', 'Punjabi', 'Hindi']),
      availableDays: List<String>.from(json['availableDays'] ?? ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']),
      timeSlots: List<String>.from(json['timeSlots'] ?? ['09:00 AM', '11:30 AM', '02:00 PM', '04:30 PM']),
      avatarUrl: json['avatarUrl'] ?? '',
      isOnlineConsultAvailable: json['isOnlineConsultAvailable'] ?? true,
      about: json['about'] ?? '',
    );
  }
}
