import 'package:flutter/material.dart';

import '../models/todo_model.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

import '../widgets/todo_card.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Todo> todos = [];

  bool isLoading = true;

  final titleController = TextEditingController();

  @override
  void initState() {
    super.initState();

    fetchTodos();
  }

  // =========================
  // GET TODOS
  // =========================

  Future<void> fetchTodos() async {
    try {
      setState(() {
        isLoading = true;
      });

      final data = await ApiService.getTodos();

      setState(() {
        todos = data;

        isLoading = false;
      });
    } catch (e) {
      print(e);

      setState(() {
        isLoading = false;
      });
    }
  }

  // =========================
  // ADD TODO
  // =========================

  Future<void> addTodo() async {
    if (titleController.text.isEmpty) {
      return;
    }

    try {
      await ApiService.addTodo(titleController.text);

      titleController.clear();

      Navigator.pop(context);

      fetchTodos();
    } catch (e) {
      print(e);
    }
  }

  // =========================
  // DELETE TODO
  // =========================

  Future<void> deleteTodo(int id) async {
    try {
      await ApiService.deleteTodo(id);

      fetchTodos();
    } catch (e) {
      print(e);
    }
  }

  // =========================
  // UPDATE STATUS
  // =========================

  Future<void> updateStatus(Todo todo) async {
    try {
      await ApiService.updateTodoStatus(todo.id, !todo.completed);

      fetchTodos();
    } catch (e) {
      print(e);
    }
  }

  // =========================
  // LOGOUT
  // =========================

  void logout() async {
    await AuthService.logout();

    if (!mounted) return;

    Navigator.pushReplacement(
      context,

      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  // =========================
  // ADD TODO DIALOG
  // =========================

  void showAddDialog() {
    showModalBottomSheet(
      context: context,

      isScrollControlled: true,

      backgroundColor: Colors.white,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),

      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 30,

            bottom: MediaQuery.of(context).viewInsets.bottom + 30,
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              const Text(
                'Tambah Todo',

                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: titleController,

                decoration: InputDecoration(
                  hintText: 'Masukkan Todo',

                  filled: true,

                  fillColor: Colors.grey.shade100,

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),

                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,

                height: 55,

                child: ElevatedButton(
                  onPressed: addTodo,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),

                  child: const Text(
                    'Simpan Todo',

                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // =========================
  // BUILD UI
  // =========================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      // =====================
      // APP BAR
      // =====================
      appBar: AppBar(
        elevation: 0,

        backgroundColor: Colors.transparent,

        foregroundColor: Colors.black,

        title: const Text(
          'Todo App',

          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        actions: [
          IconButton(onPressed: logout, icon: const Icon(Icons.logout)),
        ],
      ),

      // =====================
      // FLOATING BUTTON
      // =====================
      floatingActionButton: FloatingActionButton(
        onPressed: showAddDialog,

        backgroundColor: Colors.blue,

        child: const Icon(Icons.add),
      ),

      // =====================
      // BODY
      // =====================
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const Text(
                'My Tasks',

                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              Text(
                '${todos.length} tugas tersedia',

                style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
              ),

              const SizedBox(height: 30),

              // =================
              // CONTENT
              // =================
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : todos.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: const [
                            Icon(
                              Icons.inbox_outlined,

                              size: 100,

                              color: Colors.grey,
                            ),

                            SizedBox(height: 20),

                            Text(
                              'Belum ada todo',

                              style: TextStyle(
                                fontSize: 20,

                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          int crossAxisCount = constraints.maxWidth > 700
                              ? 2
                              : 1;

                          return GridView.builder(
                            itemCount: todos.length,

                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,

                                  crossAxisSpacing: 16,

                                  mainAxisSpacing: 16,

                                  childAspectRatio: 2.8,
                                ),

                            itemBuilder: (context, index) {
                              final todo = todos[index];

                              return GestureDetector(
                                onTap: () {
                                  updateStatus(todo);
                                },

                                child: TodoCard(
                                  todo: todo,

                                  onDelete: () {
                                    deleteTodo(todo.id);
                                  },
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
