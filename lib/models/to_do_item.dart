class ToDoItem {
  final String title;
  bool isDone;
  bool isFavorite;

  ToDoItem({required this.title, this.isFavorite = false, this.isDone = false});
}
