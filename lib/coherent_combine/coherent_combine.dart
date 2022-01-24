import 'dart:math';
import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'coherent_combine_viewModel.dart';

class CoherentCombine extends HookConsumerWidget {
  const CoherentCombine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(coherentCombineViewModelProvider);
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Container(
              //color: Colors.red,
              ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: SfRadialGauge(
                  axes: <RadialAxis>[
                    RadialAxis(
                      minimum: 0,
                      maximum: 100,
                      ranges: <GaugeRange>[
                        GaugeRange(
                            startValue: 0, endValue: 30, color: Colors.red),
                        GaugeRange(
                            startValue: 30, endValue: 70, color: Colors.orange),
                        GaugeRange(
                            startValue: 70, endValue: 100, color: Colors.green)
                      ],
                      pointers: <GaugePointer>[
                        NeedlePointer(value: viewModel.combineRate)
                      ],
                      annotations: <GaugeAnnotation>[
                        GaugeAnnotation(
                          widget: Text(
                            '${viewModel.combineRate.round()} %',
                            style: const TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          angle: 90,
                          positionFactor: 0.5,
                        )
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SfLinearGauge(
                        minimum: viewModel.idealDistanceFromEnd - 0.1,
                        maximum: viewModel.idealDistanceFromEnd + 0.1,
                        interval: 0.05,
                        markerPointers: const [
                          /*LinearShapePointer(
                            value: 50,
                          ),*/
                        ],
                        barPointers: viewModel.barPointers,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          'Delta: ${((viewModel.distanceFromStartList[1] - viewModel.distanceFromStartList[0]).abs() * 1000).round() / 1000} mm',
                          style: const TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
