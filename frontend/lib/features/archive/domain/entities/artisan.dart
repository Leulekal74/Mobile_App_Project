class ArtisanRecord {
  const ArtisanRecord({
    required this.id,
    required this.name,
    required this.specialty,
    required this.region,
    required this.experienceYears,
    required this.bio,
    required this.ownerId,
  });

  final String id;
  final String name;
  final String specialty;
  final String region;
  final int experienceYears;
  final String bio;
  final String ownerId;
}
