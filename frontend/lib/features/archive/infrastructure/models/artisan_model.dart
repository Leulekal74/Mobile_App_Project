import '../../domain/entities/artisan.dart';

class ArtisanModel extends ArtisanRecord {
  const ArtisanModel({
    required super.id,
    required super.name,
    required super.specialty,
    required super.region,
    required super.experienceYears,
    required super.bio,
    required super.ownerId,
  });

  factory ArtisanModel.fromJson(Map<String, dynamic> json) {
    return ArtisanModel(
      id: json['id'] as String,
      name: json['name'] as String,
      specialty: (json['specialty'] ?? '') as String,
      region: (json['region'] ?? '') as String,
      experienceYears: (json['experienceYears'] ?? 0) as int,
      bio: (json['bio'] ?? '') as String,
      ownerId: (json['ownerId'] ?? '') as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialty': specialty,
      'region': region,
      'experienceYears': experienceYears,
      'bio': bio,
      'ownerId': ownerId,
    };
  }
}
