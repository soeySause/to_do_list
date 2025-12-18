import 'package:flutter/material.dart';
import '../models/to_do_item.dart';


class MyAppState extends ChangeNotifier {
  List<ToDoItem> itemList = [];
  List<ToDoItem> completedItemList = [];

  void addIem(ToDoItem newItem) {
    itemList.add(newItem);
    notifyListeners();
  }

  void favoriteItem(ToDoItem item) {
    itemList.remove(item);

    if (item.isFavorite) {
      final insertIndex = itemList.indexWhere((e) => !e.isFavorite);
      if (insertIndex == -1) {
        itemList.add(item);
      } else {
        itemList.insert(insertIndex, item);
      }
    } else {
      itemList.insert(0, item);
    }

    item.isFavorite = !item.isFavorite;
    notifyListeners();
  }

  void completeItem(ToDoItem item) {
    item.isDone = !item.isDone;
    itemList.remove(item);
    completedItemList.add(item);

    notifyListeners();
  }

  void resotreItem(ToDoItem item) {
    item.isDone = !item.isDone;
    completedItemList.remove(item);
    itemList.add(item);

    item.isFavorite =
        !item.isFavorite; // favotiteItem() will flip favoite var back
    favoriteItem(item);

    notifyListeners();
  }
}
