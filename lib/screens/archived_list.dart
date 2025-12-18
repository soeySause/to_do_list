import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../states/app_sate.dart';
import '../widgets/to_do_list_item_archived.dart';

class ArchivedPage extends StatelessWidget {
  const ArchivedPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return ListView(
      children: [
        for (int i = 0; i < appState.completedItemList.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ToDoListItemArchived(i: i),
          ),
      ],
    );
  }
}
