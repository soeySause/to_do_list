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

// TODO FOR DEC 18
// make the coloum scrollabel if you add too many items app breaks

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
    switch (selectedIndex) {
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
          Expanded(child: Container(child: page)),
        ],
      ),
    );
  }
}

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
            appState.resotreItem(item);
          },
          icon: Icon(Icons.restore),
          label: Text("Restore"),
        ),
      ],
    );
  }
}
