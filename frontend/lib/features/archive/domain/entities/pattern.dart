class PatternRecord {
  const PatternRecord({
    required this.id,
    required this.name,
    required this.region,
    required this.technique,
    required this.description,
    required this.threadCount,
    required this.ownerId,
  });

  final String id;
  final String name;
  final String region;
  final String technique;
  final String description;
  final String threadCount;
  final String ownerId;
}
