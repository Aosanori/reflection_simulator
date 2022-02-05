import 'package:flutter_test/flutter_test.dart';

import 'package:reflection_simulator/utils/environments_variables.dart';
import 'package:reflection_simulator/utils/graph.dart';

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

    test('Reference of Optics Position are different', () {
      final modelA = initialOpticsList[0];

      final modelB = modelA.copy();

      modelB.position.x = -200;

      expect(modelA.position.x != modelB.position.x, true);
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

    test('Node Instances are different', () {
      final modelA = Node(
        '1',
        initialOpticsList[1],
      );

      final modelB = modelA.copy();
      modelB.data.id = 'test';
      expect(modelA.data.id != modelB.data.id, true);
    });
  });
}
