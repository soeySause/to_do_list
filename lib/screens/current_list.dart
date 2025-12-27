import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../states/app_sate.dart';
import '../widgets/to_do_list_item.dart';
import '../widgets/to_do_list_add_bar.dart';

class CurrentPage extends StatelessWidget {
  const CurrentPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              for (int i = 0; i < appState.itemList.length; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ToDoListItem(i: i),
                ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            bottom: 10
            ), 
          child: ToDoListAddBar()
          ),
      ],
    );
  }
}
