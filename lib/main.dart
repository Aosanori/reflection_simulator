import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'laser_information/laser_information_display.dart';
import 'laser_reflection_position_display/laser_reflection_position_display.dart';
import 'optics_diagram/optics_diagram.dart';
import 'optics_display/opticts_display.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(),
      );
}

class MyHomePage extends HookConsumerWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
        appBar: AppBar(
          title: const Text('Reflection Simulater'),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 2,
                    child: Card(
                      elevation: 5,
                      child: Container(
                        color: Colors.white,
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: const OpticsDisplay(),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Card(
                      elevation: 5,
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: const OpticsDiagram(),
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
                    flex: 2,
                    child: Card(
                      elevation: 5,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: const LaserRefalactionPositionListDisplay(),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      elevation: 5,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: const LaserInformationDisplay(),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: null,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      );
}
/*
class AddOpticsFloatingActionButton extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final optics
    return FloatingActionButton(
      onPressed: null,
      tooltip: 'Increment',
      child: const Icon(Icons.add),
    );
  }
}
*/