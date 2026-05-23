class DyeRecord {
  const DyeRecord({
    required this.id,
    required this.name,
    required this.sourceMaterial,
    required this.region,
    required this.formula,
    required this.notes,
    required this.ownerId,
  });

  final String id;
  final String name;
  final String sourceMaterial;
  final String region;
  final String formula;
  final String notes;
  final String ownerId;
}
