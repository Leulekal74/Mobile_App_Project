import '../../domain/entities/pattern.dart';

class PatternModel extends PatternRecord {
  const PatternModel({
    required super.id,
    required super.name,
    required super.region,
    required super.technique,
    required super.description,
    required super.threadCount,
    required super.ownerId,
  });

  factory PatternModel.fromJson(Map<String, dynamic> json) {
    return PatternModel(
      id: json['id'] as String,
      name: json['name'] as String,
      region: (json['region'] ?? '') as String,
      technique: (json['technique'] ?? '') as String,
      description: (json['description'] ?? '') as String,
      threadCount: (json['threadCount'] ?? '') as String,
      ownerId: (json['ownerId'] ?? '') as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'region': region,
      'technique': technique,
      'description': description,
      'threadCount': threadCount,
      'ownerId': ownerId,
    };
  }
}
