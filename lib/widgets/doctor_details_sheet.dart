import 'package:material_ui/material_ui.dart';

import '../core/constants/app_constants.dart';
import '../models/doctor.dart';
import 'booking_sheet.dart';
import 'doctor_profile_overview.dart';
import 'primary_button.dart';

/// Opens the doctor profile sheet and, if requested, the booking flow.
Future<void> showDoctorDetails(BuildContext context, Doctor doctor) async {
  final bool? shouldBook = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (BuildContext sheetContext) => DoctorDetailsSheet(doctor: doctor),
  );

  if (shouldBook == true && context.mounted) {
    await showBookingSheet(context, doctor: doctor);
  }
}

/// Detailed doctor profile presented as a modal sheet.
class DoctorDetailsSheet extends StatelessWidget {
  const DoctorDetailsSheet({super.key, required this.doctor});

  final Doctor doctor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 560,
          maxHeight: MediaQuery.sizeOf(context).height * 0.9,
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                child: DoctorProfileOverview(doctor: doctor),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                4,
                20,
                20 + MediaQuery.paddingOf(context).bottom,
              ),
              child: PrimaryButton(
                key: const Key('doctor_book_button'),
                label: AppStrings.bookAppointment,
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
