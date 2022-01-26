import 'dart:math';
import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'coherent_combine_viewModel.dart';


class CoherentCombine extends HookConsumerWidget {
  const CoherentCombine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(coherentCombineViewModelProvider);
    return Column(
      children: [
        Expanded(
          child: Column(
            children: [
              Row(children: [Text('Change:'),
                /*DropdownButton<String>(
                  value: editOpticsDialogViewModel.editOptics.type,
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 30,
                  elevation: 16,
                  underline: Container(
                    height: 2,
                    color: Colors.grey,
                  ),
                  onChanged: editOpticsDialogViewModel.changeOpticsType,
                  items: opticsTypes
                      .map<DropdownMenuItem<String>>(
                        (value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ),
                      )
                      .toList(),
                ),*/
              ],),
              SfCartesianChart(
                series: <ChartSeries>[
                  // Renders line chart
                  LineSeries<ChartData, double>(
                    dataSource: viewModel.chartData,
                    xValueMapper: (ChartData sales, _) => sales.year,
                    yValueMapper: (ChartData sales, _) => sales.sales,
                  )
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: SfRadialGauge(
                  axes: <RadialAxis>[
                    RadialAxis(
                      minimum: 0,
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
