import 'package:material_ui/material_ui.dart';

import '../../models/appointment.dart';
import '../../models/doctor.dart';
import '../../models/lab_availability_slot.dart';
import '../../models/health_category.dart';
import '../../models/diagnostic_test.dart';
import '../../models/health_checkup_package.dart';
import '../../models/laboratory.dart';
import '../../models/patient.dart';
import '../constants/app_colors.dart';

/// Local sample content powering the frontend demo.
abstract final class DemoData {
  static const List<HealthCategory> categories = <HealthCategory>[
    HealthCategory(
      name: 'General Physician',
      icon: Icons.medical_services_outlined,
      color: AppColors.primary,
    ),
    HealthCategory(
      name: 'Cardiologist',
      icon: Icons.monitor_heart_outlined,
      color: AppColors.secondary,
    ),
    HealthCategory(
      name: 'Dermatologist',
      icon: Icons.spa_outlined,
      color: Color(0xFF9B6FD0),
    ),
    HealthCategory(
      name: 'Dentist',
      icon: Icons.medical_information_outlined,
      color: AppColors.warning,
    ),
    HealthCategory(
      name: 'Neurologist',
      icon: Icons.psychology_outlined,
      color: Color(0xFF4C7FC4),
    ),
    HealthCategory(
      name: 'Orthopedic',
      icon: Icons.accessibility_new_rounded,
      color: AppColors.success,
    ),
  ];

  static const List<Doctor> doctors = <Doctor>[
    Doctor(
      id: 'dr-ananya-rao',
      name: 'Dr. Ananya Rao',
      specialty: 'Cardiologist',
      rating: 4.9,
      reviewCount: 320,
      fee: 650,
      experienceYears: 12,
      about:
          'Fictional demo profile. Dr. Ananya Rao represents a cardiology '
          'specialist with a sample focus on preventive heart health, blood '
          'pressure care and cardiac rehabilitation. This profile highlights '
          'reviewing heart-health concerns, explaining care options clearly '
          'and supporting shared decisions with patients. It does not describe '
          'a real clinician or provide medical advice.',
      languages: <String>['English', 'Hindi', 'Kannada'],
      clinic: 'USHA Demo Heart Clinic',
      qualification: 'Fictional demo qualification: MBBS, MD (Cardiology)',
      clinicLocation: 'Indiranagar, Bengaluru',
      availabilityInfo: 'Demo slots vary by date; see the booking schedule.',
      isVerified: false,
    ),
    Doctor(
      id: 'dr-vikram-mehta',
      name: 'Dr. Vikram Mehta',
      specialty: 'General Physician',
      rating: 4.8,
      reviewCount: 210,
      fee: 450,
      experienceYears: 9,
      about:
          'Fictional demo profile. Dr. Vikram Mehta represents a general '
          'physician with a sample interest in preventive care, common '
          'health concerns and long-term wellness discussions. The profile '
          'emphasises listening carefully, sharing clear information and '
          'helping patients consider appropriate next steps. It does not '
          'describe a real clinician or provide medical advice.',
      languages: <String>['English', 'Hindi'],
      clinic: 'USHA Demo Family Clinic',
      qualification:
          'Fictional demo qualification: MBBS, MD (General Medicine)',
      clinicLocation: 'Whitefield, Bengaluru',
      availabilityInfo: 'Demo slots vary by date; see the booking schedule.',
      isVerified: false,
    ),
    Doctor(
      id: 'dr-sneha-kapoor',
      name: 'Dr. Sneha Kapoor',
      specialty: 'Dermatologist',
      rating: 4.9,
      reviewCount: 185,
      fee: 550,
      experienceYears: 8,
      about:
          'Fictional demo profile. Dr. Sneha Kapoor represents a dermatology '
          'specialist with sample areas of interest including acne, '
          'pigmentation and skin sensitivities. The profile describes a '
          'patient-centred approach that explains care options and supports '
          'individual questions. It does not describe a real clinician or '
          'provide medical advice.',
      languages: <String>['English', 'Hindi', 'Marathi'],
      clinic: 'USHA Demo Skin Clinic',
      qualification: 'Fictional demo qualification: MBBS, MD (Dermatology)',
      clinicLocation: 'Koramangala, Bengaluru',
      availabilityInfo: 'Demo slots vary by date; see the booking schedule.',
      isVerified: false,
    ),
    Doctor(
      id: 'dr-arjun-nair',
      name: 'Dr. Arjun Nair',
      specialty: 'Neurologist',
      rating: 4.7,
      reviewCount: 140,
      fee: 750,
      experienceYears: 14,
      about:
          'Fictional demo profile. Dr. Arjun Nair represents a neurology '
          'specialist with sample interests in migraine, sleep concerns and '
          'nerve-related health discussions. The profile highlights careful '
          'listening, clear explanations and collaborative care planning. It '
          'does not describe a real clinician or provide medical advice.',
      languages: <String>['English', 'Malayalam', 'Hindi'],
      clinic: 'USHA Demo Neurology Clinic',
      qualification: 'Fictional demo qualification: MBBS, DM (Neurology)',
      clinicLocation: 'Jubilee Hills, Hyderabad',
      availabilityInfo: 'Demo slots vary by date; see the booking schedule.',
      isVerified: false,
    ),
    Doctor(
      id: 'dr-priya-desai',
      name: 'Dr. Priya Desai',
      specialty: 'Dentist',
      rating: 4.8,
      reviewCount: 96,
      fee: 400,
      experienceYears: 7,
      about:
          'Fictional demo profile. Dr. Priya Desai represents a dental '
          'professional with sample interests in preventive oral care, '
          'restorative dentistry and family-focused education. The profile '
          'emphasises explaining options in accessible language and making '
          'space for patient questions. It does not describe a real clinician '
          'or provide medical advice.',
      languages: <String>['English', 'Gujarati', 'Hindi'],
      clinic: 'USHA Demo Dental Clinic',
      qualification: 'Fictional demo qualification: BDS, MDS (Dentistry)',
      clinicLocation: 'Banjara Hills, Hyderabad',
      availabilityInfo: 'Demo slots vary by date; see the booking schedule.',
      isVerified: false,
    ),
    Doctor(
      id: 'dr-rohan-iyer',
      name: 'Dr. Rohan Iyer',
      specialty: 'Orthopedic',
      rating: 4.9,
      reviewCount: 260,
      fee: 600,
      experienceYears: 11,
      about:
          'Fictional demo profile. Dr. Rohan Iyer represents an orthopaedic '
          'specialist with sample interests in joint health, sports injuries '
          'and rehabilitation discussions. The profile describes a '
          'collaborative approach that encourages clear communication about '
          'care options and recovery goals. It does not describe a real '
          'clinician or provide medical advice.',
      languages: <String>['English', 'Tamil', 'Hindi'],
      clinic: 'USHA Demo Orthopedic Clinic',
      qualification: 'Fictional demo qualification: MBBS, MS (Orthopaedics)',
      clinicLocation: 'HSR Layout, Bengaluru',
      availabilityInfo: 'Demo slots vary by date; see the booking schedule.',
      isVerified: false,
    ),
  ];

  static Doctor? doctorById(String id) {
    for (final Doctor doctor in doctors) {
      if (doctor.id == id) {
        return doctor;
      }
    }
    return null;
  }

  /// Fictional recurring lab slots and per-slot capacities for the UI demo.
  static const List<LabAvailabilitySlot> labBookingAvailability =
      <LabAvailabilitySlot>[
        LabAvailabilitySlot(
          laboratoryId: 'demo-lab-indiranagar',
          weekdays: <int>[1, 2, 3, 4, 5, 6],
          hour: 9,
          minute: 0,
          capacity: 2,
        ),
        LabAvailabilitySlot(
          laboratoryId: 'demo-lab-indiranagar',
          weekdays: <int>[1, 2, 3, 4, 5, 6],
          hour: 11,
          minute: 0,
          capacity: 3,
        ),
        LabAvailabilitySlot(
          laboratoryId: 'demo-lab-indiranagar',
          weekdays: <int>[1, 2, 3, 4, 5, 6],
          hour: 16,
          minute: 30,
          capacity: 2,
        ),
        LabAvailabilitySlot(
          laboratoryId: 'demo-lab-whitefield',
          weekdays: <int>[1, 2, 3, 4, 5, 6, 7],
          hour: 8,
          minute: 0,
          capacity: 2,
        ),
        LabAvailabilitySlot(
          laboratoryId: 'demo-lab-whitefield',
          weekdays: <int>[1, 2, 3, 4, 5, 6, 7],
          hour: 10,
          minute: 0,
          capacity: 3,
        ),
        LabAvailabilitySlot(
          laboratoryId: 'demo-lab-whitefield',
          weekdays: <int>[1, 2, 3, 4, 5, 6, 7],
          hour: 16,
          minute: 0,
          capacity: 2,
        ),
        LabAvailabilitySlot(
          laboratoryId: 'demo-lab-jubilee-hills',
          weekdays: <int>[1, 2, 3, 4, 5, 6, 7],
          hour: 8,
          minute: 0,
          capacity: 2,
        ),
        LabAvailabilitySlot(
          laboratoryId: 'demo-lab-jubilee-hills',
          weekdays: <int>[1, 2, 3, 4, 5, 6, 7],
          hour: 10,
          minute: 30,
          capacity: 3,
        ),
        LabAvailabilitySlot(
          laboratoryId: 'demo-lab-jubilee-hills',
          weekdays: <int>[1, 2, 3, 4, 5, 6, 7],
          hour: 16,
          minute: 30,
          capacity: 1,
        ),
      ];

  static const List<Laboratory> laboratories = <Laboratory>[
    Laboratory(
      id: 'demo-lab-indiranagar',
      name: 'USHA DemoCare Diagnostics - Indiranagar',
      address: '12 Sample Street',
      locality: 'Indiranagar',
      city: 'Bengaluru',
      operatingHours: 'Mon-Sat, 6:30 AM-8:00 PM',
      supportsHomeSampleCollection: true,
      tests: <DiagnosticTest>[
        DiagnosticTest(
          id: 'ind-cbc',
          name: 'Complete Blood Count (CBC)',
          price: 450,
          preparationInstructions: 'No fasting required.',
        ),
        DiagnosticTest(
          id: 'ind-hba1c',
          name: 'HbA1c',
          price: 650,
          preparationInstructions: 'No fasting required.',
        ),
        DiagnosticTest(
          id: 'ind-lipid-profile',
          name: 'Lipid Profile',
          price: 850,
          preparationInstructions: 'Fast for 9-12 hours; water is allowed.',
        ),
        DiagnosticTest(
          id: 'ind-thyroid-profile',
          name: 'Thyroid Profile',
          price: 700,
        ),
      ],
      packages: <HealthCheckupPackage>[
        HealthCheckupPackage(
          id: 'ind-wellness-screen',
          name: 'Essential Wellness Screen',
          description:
              'A broad baseline health screen for routine preventive care.',
          price: 2299,
          includedTestIds: <String>[
            'ind-cbc',
            'ind-hba1c',
            'ind-lipid-profile',
            'ind-thyroid-profile',
          ],
        ),
        HealthCheckupPackage(
          id: 'ind-diabetes-screen',
          name: 'Diabetes Health Screen',
          description:
              'A focused screen with tests commonly discussed during '
              'diabetes monitoring.',
          price: 1199,
          includedTestIds: <String>['ind-hba1c', 'ind-lipid-profile'],
        ),
      ],
    ),
    Laboratory(
      id: 'demo-lab-whitefield',
      name: 'USHA DemoLife Labs - Whitefield',
      address: '34 Fictional Tech Park Road',
      locality: 'Whitefield',
      city: 'Bengaluru',
      operatingHours: 'Daily, 7:00 AM-7:00 PM',
      supportsHomeSampleCollection: false,
      tests: <DiagnosticTest>[
        DiagnosticTest(
          id: 'wh-fasting-glucose',
          name: 'Fasting Blood Glucose',
          price: 300,
          preparationInstructions: 'Fast for 8-10 hours; water is allowed.',
        ),
        DiagnosticTest(
          id: 'wh-liver-function',
          name: 'Liver Function Test',
          price: 950,
          preparationInstructions: 'No fasting required.',
        ),
        DiagnosticTest(id: 'wh-vitamin-d', name: 'Vitamin D', price: 1100),
        DiagnosticTest(
          id: 'wh-kidney-function',
          name: 'Kidney Function Test',
          price: 900,
        ),
      ],
      packages: <HealthCheckupPackage>[
        HealthCheckupPackage(
          id: 'wh-metabolic-screen',
          name: 'Metabolic Health Screen',
          description:
              'A demo package covering glucose, liver and kidney health '
              'markers.',
          price: 1899,
          includedTestIds: <String>[
            'wh-fasting-glucose',
            'wh-liver-function',
            'wh-kidney-function',
          ],
        ),
      ],
    ),
    Laboratory(
      id: 'demo-lab-jubilee-hills',
      name: 'USHA Demo Diagnostics - Jubilee Hills',
      address: '8 Example Avenue',
      locality: 'Jubilee Hills',
      city: 'Hyderabad',
      operatingHours: 'Mon-Sun, 7:00 AM-6:00 PM',
      supportsHomeSampleCollection: true,
      tests: <DiagnosticTest>[
        DiagnosticTest(
          id: 'jh-cbc',
          name: 'Complete Blood Count (CBC)',
          price: 500,
          preparationInstructions: 'No fasting required.',
        ),
        DiagnosticTest(id: 'jh-thyroid', name: 'Thyroid Profile', price: 750),
        DiagnosticTest(id: 'jh-vitamin-b12', name: 'Vitamin B12', price: 950),
      ],
      packages: <HealthCheckupPackage>[
        HealthCheckupPackage(
          id: 'jh-wellness-panel',
          name: 'Everyday Wellness Panel',
          description:
              'A fictional preventive checkup package with common blood '
              'health markers.',
          price: 1799,
          includedTestIds: <String>['jh-cbc', 'jh-thyroid', 'jh-vitamin-b12'],
        ),
      ],
    ),
  ];

  static List<Doctor> get popularDoctors => doctors.take(3).toList();

  static final Patient seedPatient = Patient(
    fullName: 'Jordan Mathew',
    email: 'test@usha.com',
    mobile: '+91 98765 43210',
    dateOfBirth: DateTime(1997, 4, 18),
    gender: Gender.male,
    bloodGroup: 'O+',
    heightCm: 176,
    weightKg: 72,
    houseNumber: '12B',
    street: 'Palm Grove Apartments, MG Road',
    city: 'Bengaluru',
    state: 'Karnataka',
    pinCode: '560001',
  );

  static final List<Appointment> upcomingAppointments = <Appointment>[
    Appointment(
      id: 'appt-upcoming-1',
      doctor: doctors[0],
      scheduledAt: DateTime(2026, 11, 24, 10, 30),
      mode: AppointmentMode.video,
      notes: 'Please keep your recent ECG report handy for the consultation.',
    ),
    Appointment(
      id: 'appt-upcoming-2',
      doctor: doctors[2],
      scheduledAt: DateTime(2026, 11, 28, 17, 0),
      mode: AppointmentMode.inClinic,
      notes: 'Follow-up for skin allergy review.',
    ),
  ];

  static Appointment get upcomingAppointment => upcomingAppointments.first;

  static final List<Appointment> pastAppointments = <Appointment>[
    Appointment(
      id: 'appt-past-1',
      doctor: doctors[1],
      scheduledAt: DateTime(2026, 11, 2, 18, 0),
      mode: AppointmentMode.inClinic,
      status: AppointmentStatus.completed,
      notes: 'Seasonal allergy follow-up completed.',
    ),
    Appointment(
      id: 'appt-past-2',
      doctor: doctors[4],
      scheduledAt: DateTime(2026, 10, 12, 11, 0),
      mode: AppointmentMode.video,
      status: AppointmentStatus.completed,
      notes: 'Prescription shared after the consultation.',
    ),
    Appointment(
      id: 'appt-past-3',
      doctor: doctors[3],
      scheduledAt: DateTime(2026, 9, 20, 9, 30),
      mode: AppointmentMode.video,
      status: AppointmentStatus.cancelled,
      notes: 'Cancelled by the patient.',
    ),
  ];
}
