import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
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
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Text('Change: '),
                    DropdownButton<String>(
                      value: viewModel.targetOptics.name,
                      icon: const Icon(Icons.arrow_drop_down),
                      elevation: 16,
                      onChanged: viewModel.changeTargetOptics,
                      items: viewModel.opticsNameList
                          .map<DropdownMenuItem<String>>(
                            (value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text('X axis: '),
                    DropdownButton<String>(
                      value: viewModel.targetValue,
                      icon: const Icon(Icons.arrow_drop_down),
                      elevation: 16,
                      onChanged: viewModel.changeTargetValue,
                      items: viewModel.targetValues
                          .map<DropdownMenuItem<String>>(
                            (value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    TextButton(
                      onPressed: viewModel.downloadCSV,
                      child: const Text('Download CSV'),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 8,
                child: SfCartesianChart(
                  series: <ChartSeries>[
                    // Renders line chart
                    LineSeries<ChartData, double>(
                      dataSource: viewModel.chartData,
                      xValueMapper: (data, _) => data.x,
                      yValueMapper: (data, _) => data.y,
                      xAxisName: viewModel.targetValue,
                      yAxisName: 'Combine Rate',
                    )
                  ],
                  primaryXAxis: NumericAxis(
                    rangePadding: ChartRangePadding.round,
                    title: AxisTitle(
                      text: viewModel.targetValue,
                    ),
                  ),
                  primaryYAxis: NumericAxis(
                    title: AxisTitle(
                      text: 'Combine Rate',
                    ),
                  ),
                ),
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
