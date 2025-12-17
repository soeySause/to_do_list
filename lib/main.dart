import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'To Do List App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        ),
        home: HomeScreen(),
      ),
    );
  }
}

class ToDoItem {
  final String title;
  bool isDone;
  bool isFavorite;

  ToDoItem({required this.title, this.isFavorite = false, this.isDone = false});
}

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
}

// TODO FOR DEC 18
// make the coloum scrollabel if you add too many items app breaks
// implement sort button
// remove the completed items list, and create a shown list that communicates with item list
// shown list is always the one shown, and contains itmelist - any filters at all times

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {

    Widget page;
      switch(selectedIndex) {
        case 0:
          page = CurrentPage();
        case 1:
          page = ArchivedPage();
        default:
          throw UnimplementedError('no widget for $selectedIndex');
          
      }

    return Scaffold(
      appBar: AppBar(title: const Text('To Do List')),
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              extended: false,
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FilterButton(),
              ),
              destinations: [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.history),
                  label: Text('Archive'),
                ),
              ],
              selectedIndex: selectedIndex,
              onDestinationSelected: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
            ),
          ),
          Expanded(
            child: Container(
              child: page,
            ),
          ),
        ],
      ),
    );
  }
}

class CurrentPage extends StatelessWidget {
  const CurrentPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Column(
      children: [
        Expanded(
          child: Column(
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
        ToDoListAddBar(),
      ],
    );
  }
}

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
          child: Text("Complete"),
        ),
        SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            appState.completeItem(item);
          },
          child: Text("Delete"),
        ),
      ],
    );
  }
}

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


class ArchivedPage extends StatelessWidget {
  const ArchivedPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Column(
      children: [
        for (int i = 0; i < appState.completedItemList.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: ArchivedToDoListItem(i: i),
          ),
      ],
    );
  }
}

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
            print("pressed");
          },
          icon: Icon(Icons.restore),
          label: Text("Restore"),
        ),
      ],
    );
  }
}



class FilterButton extends StatefulWidget {
  @override
  _FilterButtonState createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  final List<String> options = ['Favorite', 'Completed', 'Deleted'];
  final Set<String> selectedOptions = {};

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (context) {
        return options.map((option) {
          return PopupMenuItem<String>(
            value: option,
            enabled: false, // IMPORTANT
            child: StatefulBuilder(
              builder: (context, setStatePopup) {
                return CheckboxListTile(
                  title: Text(option),
                  value: selectedOptions.contains(option),
                  onChanged: (checked) {
                    setState(() {
                      if (checked == true) {
                        selectedOptions.add(option);
                      } else {
                        selectedOptions.remove(option);
                      }
                    });
                    setStatePopup(() {});
                  },
                );
              },
            ),
          );
        }).toList();
      },
      child: ElevatedButton(
        onPressed: null,
        child: Text(
          selectedOptions.isEmpty
              ? 'Filter'
              : 'Filter (${selectedOptions.length})',
        ),
      ),
    );
  }
}
