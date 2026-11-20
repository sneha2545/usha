/// Gender options captured during registration.
enum Gender { male, female, other }

extension GenderLabel on Gender {
  String get label {
    switch (this) {
      case Gender.male:
        return 'Male';
      case Gender.female:
        return 'Female';
      case Gender.other:
        return 'Other';
    }
  }
}

/// Patient profile shared across registration, dashboard and profile screens.
///
/// The model is immutable; edits create a new instance through [copyWith] and
/// the [PatientStore] notifies listeners.
class Patient {
  const Patient({
    required this.fullName,
    required this.email,
    required this.mobile,
    required this.dateOfBirth,
    required this.gender,
    required this.bloodGroup,
    required this.heightCm,
    required this.weightKg,
    required this.houseNumber,
    required this.street,
    required this.city,
    required this.state,
    required this.pinCode,
  });

  final String fullName;
  final String email;
  final String mobile;
  final DateTime dateOfBirth;
  final Gender gender;
  final String bloodGroup;
  final int heightCm;
  final int weightKg;
  final String houseNumber;
  final String street;
  final String city;
  final String state;
  final String pinCode;

  /// Age in completed years, derived from [dateOfBirth] on every read.
  int get age => ageFrom(dateOfBirth);

  String get initials {
    final List<String> parts = fullName
        .trim()
        .split(' ')
        .where((String part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) {
      return 'U';
    }
    return parts
        .take(2)
        .map((String part) => part[0].toUpperCase())
        .join();
  }

  String get firstName {
    final List<String> parts = fullName
        .trim()
        .split(' ')
        .where((String part) => part.isNotEmpty)
        .toList();
    return parts.isEmpty ? 'there' : parts.first;
  }

  String get heightLabel => '$heightCm cm';

  String get weightLabel => '$weightKg kg';

  static int ageFrom(DateTime dateOfBirth) {
    final DateTime now = DateTime.now();
    int years = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      years--;
    }
    return years < 0 ? 0 : years;
  }

  Patient copyWith({
    String? fullName,
    String? email,
    String? mobile,
    DateTime? dateOfBirth,
    Gender? gender,
    String? bloodGroup,
    int? heightCm,
    int? weightKg,
    String? houseNumber,
    String? street,
    String? city,
    String? state,
    String? pinCode,
  }) {
    return Patient(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      houseNumber: houseNumber ?? this.houseNumber,
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      pinCode: pinCode ?? this.pinCode,
    );
  }
}
