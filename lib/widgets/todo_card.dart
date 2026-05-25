import 'package:flutter/material.dart';
import '../models/todo_model.dart';

class TodoCard extends StatelessWidget {
  final Todo todo;
  final VoidCallback onDelete;

  const TodoCard({super.key, required this.todo, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(20),

        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: todo.completed
                ? Colors.green.shade100
                : Colors.orange.shade100,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(
            todo.completed ? Icons.check : Icons.pending_actions,
            color: todo.completed ? Colors.green : Colors.orange,
          ),
        ),

        title: Text(
          todo.title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            decoration: todo.completed
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            todo.completed ? 'Completed' : 'Pending',
            style: TextStyle(
              color: todo.completed ? Colors.green : Colors.orange,
            ),
          ),
        ),

        trailing: IconButton(
          onPressed: onDelete,
          icon: const Icon(Icons.delete_outline, color: Colors.red),
        ),
      ),
    );
  }
}
