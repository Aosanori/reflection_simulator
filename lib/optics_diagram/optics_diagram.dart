import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'optics_list/optics_list_view.dart';
import 'optics_tree/optics_tree_view.dart';

class OpticsDiagram extends HookConsumerWidget {
  const OpticsDiagram({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) => const DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar:  TabBar(
          labelColor: Colors.blue,
            tabs: <Widget>[
              Tab(text:'List'),
              Tab(text:'Tree'),
            ],
        ),
        body: TabBarView(
          children: <Widget>[
           OpticsListView(),
           OpticsTreeView(),
          ],
        ),
      ),
    );
}
