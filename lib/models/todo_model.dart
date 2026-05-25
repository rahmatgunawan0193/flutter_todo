class Todo {
  final int id;
  final String title;
  final bool completed;
  final int userId;

  Todo({
    required this.id,
    required this.title,
    required this.completed,
    required this.userId,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      completed: json['completed'] == 1 || json['completed'] == true,
      userId: json['user_id'],
    );
  }
}
