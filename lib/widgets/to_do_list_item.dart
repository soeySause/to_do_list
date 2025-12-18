import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../states/app_sate.dart';
import '../models/to_do_item.dart';

class ToDoListItem extends StatelessWidget {
  final int i;

  const ToDoListItem({required this.i, super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    ToDoItem item = appState.itemList.elementAt(i);

    IconData icon;
    if (item.isFavorite) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Row(
      children: [
        Expanded(child: Text(item.title)),
        SizedBox(width: 10),
        ElevatedButton.icon(
          onPressed: () {
            appState.favoriteItem(item);
          },
          icon: Icon(icon),
          label: Text("Favorite"),
        ),
        SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            appState.completeItem(item);
          },
          child: Text("remove"),
        ),
      ],
    );
  }
}
