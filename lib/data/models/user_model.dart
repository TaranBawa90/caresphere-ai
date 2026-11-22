enum UserRole { patient, doctor, admin }

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final UserRole role;
  final String? avatarUrl;
  final String? bloodGroup;
  final List<String>? allergies;
  final String? emergencyContact;
  final String? emergencyContactRelation;
  final String? chronicConditions;

  // Doctor specific fields
  final String? specialization;
  final String? qualifications;
  final String? licenseNumber;
  final String? hospitalAffiliation;
  final int? experienceYears;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.avatarUrl,
    this.bloodGroup,
    this.allergies,
    this.emergencyContact,
    this.emergencyContactRelation,
    this.chronicConditions,
    this.specialization,
    this.qualifications,
    this.licenseNumber,
    this.hospitalAffiliation,
    this.experienceYears,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role.name,
      'avatarUrl': avatarUrl,
      'bloodGroup': bloodGroup,
      'allergies': allergies,
      'emergencyContact': emergencyContact,
      'emergencyContactRelation': emergencyContactRelation,
      'chronicConditions': chronicConditions,
      'specialization': specialization,
      'qualifications': qualifications,
      'licenseNumber': licenseNumber,
      'hospitalAffiliation': hospitalAffiliation,
      'experienceYears': experienceYears,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: UserRole.values.firstWhere(
        (e) => e.name == json['role'],
        orElse: () => UserRole.patient,
      ),
      avatarUrl: json['avatarUrl'],
      bloodGroup: json['bloodGroup'],
      allergies: json['allergies'] != null
          ? List<String>.from(json['allergies'])
          : null,
      emergencyContact: json['emergencyContact'],
      emergencyContactRelation: json['emergencyContactRelation'],
      chronicConditions: json['chronicConditions'],
      specialization: json['specialization'],
      qualifications: json['qualifications'],
      licenseNumber: json['licenseNumber'],
      hospitalAffiliation: json['hospitalAffiliation'],
      experienceYears: json['experienceYears'],
    );
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? phone,
    UserRole? role,
    String? avatarUrl,
    String? bloodGroup,
    List<String>? allergies,
    String? emergencyContact,
    String? emergencyContactRelation,
    String? chronicConditions,
    String? specialization,
    String? qualifications,
    String? licenseNumber,
    String? hospitalAffiliation,
    int? experienceYears,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      allergies: allergies ?? this.allergies,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      emergencyContactRelation:
          emergencyContactRelation ?? this.emergencyContactRelation,
      chronicConditions: chronicConditions ?? this.chronicConditions,
      specialization: specialization ?? this.specialization,
      qualifications: qualifications ?? this.qualifications,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      hospitalAffiliation: hospitalAffiliation ?? this.hospitalAffiliation,
      experienceYears: experienceYears ?? this.experienceYears,
    );
  }
}
