/// A doctor listed in the USHA demo directory.
class Doctor {
  const Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.reviewCount,
    required this.fee,
    required this.experienceYears,
    required this.about,
    required this.languages,
    this.clinic = 'USHA Demo Clinic',
    this.qualification,
    this.clinicLocation,
    this.profileImageAsset,
    this.availabilityInfo,
    this.isVerified = true,
  });

  final String id;
  final String name;
  final String specialty;
  final double rating;
  final int reviewCount;
  final int fee;
  final int experienceYears;
  final String about;
  final List<String> languages;
  final String clinic;
  final String? qualification;
  final String? clinicLocation;
  final String? profileImageAsset;
  final String? availabilityInfo;
  final bool isVerified;

  String get feeLabel => '₹$fee';

  String get initials {
    final String cleaned = name.startsWith('Dr. ')
        ? name.substring(4)
        : name;
    final List<String> parts = cleaned
        .split(' ')
        .where((String part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) {
      return 'DR';
    }
    return parts
        .take(2)
        .map((String part) => part[0].toUpperCase())
        .join();
  }
}
