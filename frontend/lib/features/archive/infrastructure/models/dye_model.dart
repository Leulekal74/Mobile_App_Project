import '../../domain/entities/dye.dart';

class DyeModel extends DyeRecord {
  const DyeModel({
    required super.id,
    required super.name,
    required super.sourceMaterial,
    required super.region,
    required super.formula,
    required super.notes,
    required super.ownerId,
  });

  factory DyeModel.fromJson(Map<String, dynamic> json) {
    return DyeModel(
      id: json['id'] as String,
      name: json['name'] as String,
      sourceMaterial: (json['sourceMaterial'] ?? '') as String,
      region: (json['region'] ?? '') as String,
      formula: (json['formula'] ?? '') as String,
      notes: (json['notes'] ?? '') as String,
      ownerId: (json['ownerId'] ?? '') as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sourceMaterial': sourceMaterial,
      'region': region,
      'formula': formula,
      'notes': notes,
      'ownerId': ownerId,
    };
  }
}
