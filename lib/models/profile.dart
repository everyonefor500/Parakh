enum UserRole { officer, seller, marketplace, consumer }

extension UserRoleExtension on UserRole {
  String get label {
    switch (this) {
      case UserRole.officer: return "Legal Metrology Officer";
      case UserRole.seller: return "Seller";
      case UserRole.marketplace: return "Marketplace";
      case UserRole.consumer: return "Consumer";
    }
  }
}

class Profile {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final UserRole role;
  final String? organization;
  final String? designation;
  final String? department;
  final String? state;
  final String? district;
  final String? languagePreference;
  final String? avatarUrl;
  final DateTime createdAt;

  Profile({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    this.organization,
    this.designation,
    this.department,
    this.state,
    this.district,
    this.languagePreference,
    this.avatarUrl,
    required this.createdAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      fullName: json['fullName'] ?? json['full_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: UserRole.values.firstWhere(
        (e) => e.name == (json['role'] ?? UserRole.consumer.name),
        orElse: () => UserRole.consumer,
      ),
      organization: json['organization'],
      designation: json['designation'],
      department: json['department'],
      state: json['state'],
      district: json['district'],
      languagePreference: json['languagePreference'] ?? json['language_preference'],
      avatarUrl: json['avatarUrl'] ?? json['avatar_url'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : (json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : DateTime.now()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'role': role.name,
      'organization': organization,
      'designation': designation,
      'department': department,
      'state': state,
      'district': district,
      'languagePreference': languagePreference,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
