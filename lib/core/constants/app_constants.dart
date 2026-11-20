import 'package:material_ui/material_ui.dart';

/// All user-facing copy in one place so it can be revised or localised later.
abstract final class AppStrings {
  static const String appName = 'USHA';
  static const String tagline = 'Your Health, Our Priority';
  static const String splashFooter = 'Care that connects';
  static const String version = 'Version 1.0.0';

  static const String loginTitle = 'Welcome back';
  static const String loginSubtitle = 'Sign in to continue your care journey.';
  static const String loginCardTitle = 'Account access';
  static const String loginCardSubtitle =
      'Use your registered email or mobile number.';
  static const String emailOrPhoneLabel = 'Email or mobile number';
  static const String emailLabel = 'Email address';
  static const String emailOrPhoneHint = 'you@example.com';
  static const String passwordLabel = 'Password';
  static const String passwordHint = 'Enter your password';
  static const String rememberMe = 'Remember me';
  static const String forgotPassword = 'Forgot password?';
  static const String signIn = 'Sign in';
  static const String signingIn = 'Signing in...';
  static const String noAccount = "Don't have an account?";
  static const String signUp = 'Sign up';
  static const String secureNote = 'Secure and private by design';

  static const String signUpTitle = 'Create your account';
  static const String signUpSubtitle =
      'A few details and your care journey begins.';
  static const String fullNameLabel = 'Full name';
  static const String fullNameHint = 'Jordan Mathew';
  static const String mobileLabel = 'Mobile number';
  static const String mobileHint = '+91 98765 43210';
  static const String confirmPasswordLabel = 'Confirm password';
  static const String confirmPasswordHint = 'Re-enter your password';
  static const String createAccount = 'Create account';
  static const String creatingAccount = 'Creating account...';
  static const String haveAccount = 'Already have an account?';

  static const String forgotTitle = 'Reset your password';
  static const String forgotSubtitle =
      'Enter the email linked to your USHA account and we will send a reset link.';
  static const String sendResetLink = 'Send reset link';
  static const String resetSentTitle = 'Reset link sent';
  static const String done = 'Done';

  static const String signedInSuccess = 'Signed in successfully';
  static const String helloWelcome = 'Hello, Welcome!';
  static const String homeSubtitle = "Let's take care of your health today.";
  static const String searchHint = 'Search doctors, specialists and services';
  static const String promoTitle = 'Your Health, Our Priority';
  static const String promoSubtitle =
      'Expert care, personalised for you. Book a consultation in minutes.';
  static const String bookAppointment = 'Book an appointment';
  static const String exploreLaboratoryTests = 'Explore laboratory tests';
  static const String exploreLaboratories = 'Explore laboratories';
  static const String laboratoriesTitle = 'Diagnostic laboratories';
  static const String laboratoriesSubtitle =
      'Find a laboratory and explore its tests and health checkups.';
  static const String laboratorySearchHint = 'Search laboratories or locations';
  static const String noLaboratoriesFound = 'No laboratories found';
  static const String noLaboratoriesHint =
      'Try a different laboratory name or location.';
  static const String noLaboratoriesAvailable = 'No laboratories available';
  static const String noLaboratoriesAvailableHint =
      'Laboratory information will appear here when available.';
  static const String laboratoryDetailsTitle = 'Laboratory details';
  static const String labBookingTitle = 'Book laboratory service';
  static const String labSelectedServiceLabel = 'Selected service';
  static const String labCollectionMethodLabel = 'Collection method';
  static const String labVisitLabel = 'Lab Visit';
  static const String homeCollectionLabel = 'Home Collection';
  static const String homeCollectionUnavailableForLab =
      'Home collection is not available at this laboratory.';
  static const String labBookingReviewTitle = 'Review laboratory booking';
  static const String confirmLabBooking = 'Confirm laboratory booking';
  static const String labBookingSuccess = 'Laboratory booking confirmed.';
  static const String labBookingSlotUnavailable =
      'That laboratory slot is no longer available. Choose another time.';
  static const String labNoSlotsAvailable =
      'No laboratory slots are available on this date.';
  static const String labUpcomingBookingsTitle = 'Upcoming laboratory bookings';
  static const String labPreviousBookingsTitle = 'Previous laboratory bookings';
  static const String labBookingDetailsTitle = 'Laboratory booking details';
  static const String bookThisTest = 'Book this test';
  static const String bookThisPackage = 'Book this package';
  static const String bookingCancelled = 'Laboratory booking cancelled.';
  static const String labAddressRequired = 'Complete all address fields.';
  static const String labHomeAddressLabel = 'Home collection address';
  static const String operatingHoursLabel = 'Operating hours';
  static const String homeCollectionAvailable =
      'Home sample collection available';
  static const String homeCollectionUnavailable =
      'Home sample collection unavailable';
  static const String diagnosticTestsTitle = 'Diagnostic tests';
  static const String testSearchHint = 'Search diagnostic tests';
  static const String noTestsFound = 'No tests found';
  static const String noTestsHint = 'Try a different test name.';
  static const String preparationLabel = 'Preparation';
  static const String noPreparationRequired = 'No special preparation listed.';
  static const String healthPackagesTitle = 'Health checkup packages';
  static const String includedTestsLabel = 'Included tests';
  static const String viewTestDetails = 'View test details';
  static const String viewPackageDetails = 'View package details';
  static const String demoDataNotice = 'Demo information for display only';
  static const String categoriesTitle = 'Categories';
  static const String upcomingAppointmentTitle = 'Upcoming Appointment';
  static const String viewDetails = 'View details';
  static const String popularDoctorsTitle = 'Popular Doctors';
  static const String viewProfile = 'View profile';
  static const String navHome = 'Home';
  static const String navDoctors = 'Doctors';
  static const String navAppointments = 'Appointments';
  static const String navProfile = 'Profile';
  static const String doctorsTitle = 'Doctors';
  static const String doctorsSubtitle =
      'Find the right specialist for your needs.';
  static const String appointmentsTitle = 'Appointments';
  static const String appointmentsSubtitle =
      'Your consultations, all in one place.';
  static const String profileTitle = 'Profile';
  static const String bookNewAppointment = 'Book new appointment';
  static const String allCategories = 'All';
  static const String noDoctorsFound = 'No doctors found';
  static const String noDoctorsHint = 'Try a different search or category.';
  static const String bookingTitle = 'Book appointment';
  static const String chooseDoctor = 'Choose a doctor';
  static const String chooseDate = 'Select date';
  static const String chooseTime = 'Select time';
  static const String confirmBooking = 'Confirm appointment';
  static const String appointmentRequestSent =
      'Appointment request sent. We will confirm shortly.';
  static const String appointmentBooked = 'Appointment booked successfully.';
  static const String appointmentSlotUnavailable =
      'That time slot is no longer available. Please choose another slot.';
  static const String noAvailableAppointmentSlots =
      'No available slots for this date. Please choose another date.';
  static const String bookingReviewTitle = 'Review your appointment';
  static const String checkUpcomingSlots = 'Check upcoming slots';
  static const String appointmentDetailsTitle = 'Appointment details';
  static const String doctorProfileTitle = 'Doctor profile';
  static const String bookingStatusLabel = 'Booking status';
  static const String appointmentNotesLabel = 'Consultation notes';
  static const String experienceLabel = 'Experience';
  static const String consultationFeeLabel = 'Consultation fee';
  static const String aboutLabel = 'About';
  static const String aboutDoctorLabel = 'About Doctor';
  static const String qualificationLabel = 'Qualification';
  static const String specializationLabel = 'Specialization';
  static const String clinicLabel = 'Clinic / hospital';
  static const String clinicLocationLabel = 'Location';
  static const String availabilityLabel = 'Availability';
  static const String doctorProfileDemoNotice =
      'Fictional demo profile. Qualifications and details are illustrative only.';
  static const String languagesSpokenLabel = 'Languages spoken';
  static const String doctorBioUnavailable =
      'A doctor biography is not available.';
  static const String languagesLabel = 'Languages';
  static const String availableToday = 'Available today';
  static const String notificationsTitle = 'Notifications';
  static const String markAllRead = 'Mark all as read';
  static const String allCaughtUp = "You're all caught up";
  static const String personalDetailsTitle = 'Personal Details';
  static const String accountSecurityTitle = 'Account Security';
  static const String healthInformationTitle = 'Health Information';
  static const String addressDetailsTitle = 'Address Details';
  static const String dateOfBirthLabel = 'Date of birth';
  static const String ageLabel = 'Age';
  static const String genderLabel = 'Gender';
  static const String bloodGroupLabel = 'Blood group';
  static const String heightLabel = 'Height (cm)';
  static const String weightLabel = 'Weight (kg)';
  static const String houseNumberLabel = 'House / Flat number';
  static const String streetLabel = 'Street / Area';
  static const String cityLabel = 'City';
  static const String stateLabel = 'State';
  static const String pinCodeLabel = 'PIN code';
  static const String registerButton = 'Register';
  static const String registering = 'Creating your profile...';
  static const String registrationSuccessTitle = 'Registration complete';
  static const String goToDashboard = 'Go to dashboard';
  static const String editProfile = 'Edit profile';
  static const String saveChanges = 'Save changes';
  static const String profileUpdated = 'Profile updated successfully';
  static const String personalInformationTitle = 'Personal Information';
  static const String healthProfileTitle = 'Health Profile';
  static const String addressInformationTitle = 'Address Information';
  static const String upcomingTab = 'Upcoming';
  static const String previousTab = 'Previous';
  static const String cancelAppointment = 'Cancel appointment';
  static const String cancelAppointmentTitle = 'Cancel appointment?';
  static const String keepAppointment = 'Keep appointment';
  static const String appointmentCancelled = 'Appointment cancelled.';
  static const String emptyUpcomingTitle = 'No upcoming appointments';
  static const String emptyUpcomingBody =
      'Book a consultation and it will appear here.';
  static const String emptyPreviousTitle = 'No past appointments';
  static const String emptyPreviousBody =
      'Completed and cancelled consultations will appear here.';
  static const String emailProfileNote =
      'Changing your profile email does not change demo sign-in credentials.';
  static const String authErrorMessage =
      'Incorrect email or password. Please use the demo credentials below.';
  static const String demoAccessTitle = 'Demo access';
  static const String demoFillAction = 'Fill';
  static const String notificationsEmpty = 'You are all caught up.';
  static const String signOutTitle = 'Sign out?';
  static const String signOutBody =
      'You will need your credentials to sign back in.';
  static const String cancel = 'Cancel';
  static const String signOut = 'Sign out';
  static const String accountCreatedTitle = 'Account created';
  static const String accountCreatedBody =
      'Your USHA profile is ready. You can now sign in with your credentials.';
  static const String continueLabel = 'Continue';
  static const String validationEmailOrPhone =
      'Enter a valid email or mobile number';
  static const String validationEmail = 'Enter a valid email address';
  static const String validationPassword = 'Enter your password';
  static const String validationPasswordShort =
      'Password must be at least 6 characters';
  static const String validationPasswordMismatch = 'Passwords do not match';
  static const String validationName = 'Enter your full name';
  static const String validationMobile =
      'Enter a valid 10-digit Indian mobile number starting with 6–9. +91 is optional.';
}

/// Shared spacing, sizing and radius tokens.
abstract final class AppSizes {
  static const double screenPadding = 24;
  static const double cardPadding = 24;
  static const double contentMaxWidth = 480;
  static const double buttonHeight = 56;
  static const double fieldRadius = 14;
  static const double cardRadius = 28;
  static const double headerRadius = 40;
}

/// Animation and simulated network timings.
abstract final class AppDurations {
  static const Duration splashDelay = Duration(milliseconds: 2600);
  static const Duration splashReveal = Duration(milliseconds: 1400);
  static const Duration screenTransition = Duration(milliseconds: 450);
  static const Duration authRequest = Duration(milliseconds: 1200);
  static const Duration shortRequest = Duration(milliseconds: 900);
}

/// Layout breakpoints used by responsive helpers.
abstract final class AppBreakpoints {
  static const double tablet = 600;
  static const double compactHeight = 700;
}

/// Common icon references so icon choices stay consistent.
abstract final class AppIcons {
  static const IconData logo = Icons.health_and_safety_rounded;
  static const IconData email = Icons.alternate_email_rounded;
  static const IconData lock = Icons.lock_outline_rounded;
  static const IconData person = Icons.person_outline_rounded;
  static const IconData phone = Icons.smartphone_rounded;
  static const IconData arrow = Icons.arrow_forward_rounded;
}
