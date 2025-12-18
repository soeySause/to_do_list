import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../states/app_sate.dart';
import '../models/to_do_item.dart';


class ToDoListAddBar extends StatefulWidget {
  const ToDoListAddBar({super.key});

  @override
  State<ToDoListAddBar> createState() => _ToDoListAddBarState();
}

class _ToDoListAddBarState extends State<ToDoListAddBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Add a task…',
              border: OutlineInputBorder(),
            ),
            controller: _controller,
            onSubmitted: (value) {
              ToDoItem newItem = ToDoItem(title: _controller.text);
              appState.addIem(newItem);
              _controller.clear();
            },
          ),
        ),
        SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            ToDoItem newItem = ToDoItem(title: _controller.text);
            appState.addIem(newItem);
            _controller.clear();
          },
          child: Text("Add to List"),
        ),
      ],
    );
  }
}