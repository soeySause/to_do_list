import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../states/app_sate.dart';
import '../models/to_do_item.dart';

class ArchivedToDoListItem extends StatelessWidget {
  final int i;

  const ArchivedToDoListItem({required this.i, super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    ToDoItem item = appState.completedItemList.elementAt(i);

    return Row(
      children: [
        Expanded(child: Text(item.title)),
        SizedBox(width: 10),
        ElevatedButton.icon(
          onPressed: () {
            appState.resotreItem(item);
          },
          icon: Icon(Icons.restore),
          label: Text("Restore"),
        ),
      ],
    );
  }
}
