import 'package:flutter_test/flutter_test.dart';

import 'package:reflection_simulator/utils/environments_variables.dart';

void main() {
  group('copyWith using Nullable', () {
    test('Optics Instances are different', () {
      final modelA = initialOpticsList[0];

      final modelB = modelA.copy();

      expect(modelA == modelB, false);
    });

    test('Reference of Optics Instances are different', () {
      final modelA = initialOpticsList[0];

      final modelB = modelA.copy();

      modelB.id = 'test';

      expect(modelA.id != modelB.id, true);
    });

    test('Beam Instances are different', () {
      final modelA = initialBeam;

      final modelB = modelA.copy();

      expect(modelA == modelB, false);
    });

    test('Reference of Beam Instances are different', () {
      final modelA = initialBeam;

      final modelB = modelA.copy();

      modelB.type = 'test';

      expect(modelA.type != modelB.type, true);
    });
  });
}
