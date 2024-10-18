import 'package:flutter/material.dart';
import 'package:flutter_application_2/modals/Todo.dart';
import 'package:flutter_application_2/services/notification_service.dart';
import 'package:flutter_application_2/services/task_database_helper.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  final TaskDatabaseHelper _dbHelper = TaskDatabaseHelper();

  Future<void> loadTasks({String? sortBy}) async {
    _tasks = await _dbHelper.getTasks(sortBy: sortBy);
    notifyListeners();
  }

  Future<void> addTask(Task task, BuildContext context) async {
    try {
      // Insert the task into the database
      await _dbHelper.insertTask(task);

      // Reload tasks after insertion
      await loadTasks();

      // Ensure task properties are not null before scheduling notification
      if (task.title != null && task.dueDate != null) {
        // Schedule the notification for the task
        await scheduleTaskNotification(task);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Notification scheduled successfully!'),
          ),
        );
      } else {
        // Throw an exception if required fields are null
        throw Exception('Task title or due date is null');
      }
    } catch (e) {
      // Show an error message if something goes wrong
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Error scheduling notification: $e'),
      //   ),
      // );

      print("Error: " + e.toString());
    }
  }

  Future<void> updateTask(Task task, BuildContext context) async {
    // Update task in the database
    await _dbHelper.updateTask(task);

    // Reload tasks after the update
    await loadTasks();

    // Schedule notification for the task
    await scheduleTaskNotification(task);
  }

  Future<void> deleteTask(int id) async {
    await _dbHelper.deleteTask(id);
    loadTasks();
  }

  Future<void> searchTasks(String query) async {
    if (query.isEmpty) {
      await loadTasks();
    } else {
      _tasks = _tasks
          .where((task) =>
              task.title.contains(query) || task.description.contains(query))
          .toList();
      notifyListeners();
    }
  }
}
