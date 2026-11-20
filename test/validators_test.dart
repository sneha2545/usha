import 'package:flutter_test/flutter_test.dart';
import 'package:usha/core/constants/app_constants.dart';
import 'package:usha/core/utils/validators.dart';

void main() {
  group('Validators.mobile', () {
    const List<String> validNumbers = <String>[
      '6123456789',
      '7123456789',
      '8123456789',
      '9123456789',
      '98765 43210',
      '98765-43210',
      '+91 98765 43210',
      '+91-98765-43210',
      ' +91 98765 43210 ',
    ];

    for (final String number in validNumbers) {
      test('accepts $number', () {
        expect(Validators.mobile(number), isNull);
      });
    }

    const List<String> invalidNumbers = <String>[
      '',
      '   ',
      '----------',
      '-- -- -- --',
      'abcdefghij',
      '987654321',
      '98765432101',
      '1234567890',
      '0123456789',
      '5123456789',
      '+1 98765 43210',
      '+92 98765 43210',
      '+ 91 98765 43210',
      '+9 1 98765 43210',
      '+91 98765 4321',
      '+91 18765 43210',
      '91 98765 43210',
      '+91 (98765) 43210',
      '98765.43210',
    ];

    for (final String number in invalidNumbers) {
      test('rejects $number', () {
        expect(Validators.mobile(number), AppStrings.validationMobile);
      });
    }
  });
}
