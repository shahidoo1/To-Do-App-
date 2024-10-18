import 'package:flutter/material.dart';
import 'package:flutter_application_2/modals/Todo.dart';
import 'package:flutter_application_2/viewModel/task_view_model.dart';
import 'package:provider/provider.dart';

class TaskForm extends StatefulWidget {
  final Task? task;

  TaskForm({this.task});

  @override
  _TaskFormState createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  int _priority = 1;
  DateTime _dueDate = DateTime.now().add(const Duration(days: 1));

  @override
  void initState() {
    super.initState();
    // Set the due date to the existing task's due date if available
    if (widget.task != null) {
      _dueDate = widget.task!.dueDate;
    }
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 112, 191, 254),
        title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Title TextFormField with decoration
                TextFormField(
                  initialValue: widget.task?.title,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle:
                        const TextStyle(color: Colors.blueGrey), // Label color
                    border: OutlineInputBorder(
                      // Border styling
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Colors.blueGrey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      // Focused border styling
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 2.0),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onSaved: (value) => _title = value!,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a title' : null,
                ),
                const SizedBox(height: 16),

                // Description TextFormField with decoration
                TextFormField(
                  initialValue: widget.task?.description,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle:
                        const TextStyle(color: Colors.blueGrey), // Label color
                    border: OutlineInputBorder(
                      // Border styling
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Colors.blueGrey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      // Focused border styling
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 2.0),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onSaved: (value) => _description = value!,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a description' : null,
                ),
                const SizedBox(height: 16),

                // DropdownButtonFormField with decoration
                DropdownButtonFormField(
                  value: _priority,
                  items: List.generate(3, (index) {
                    return DropdownMenuItem(
                      value: index + 1,
                      child: Text('Priority ${index + 1}'),
                    );
                  }),
                  onChanged: (value) => setState(() {
                    _priority = value as int;
                  }),
                  decoration: InputDecoration(
                    labelText: 'Priority',
                    labelStyle:
                        const TextStyle(color: Colors.blueGrey), // Label color
                    border: OutlineInputBorder(
                      // Border styling
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Colors.blueGrey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      // Focused border styling
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 2.0),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),

                // Due Date Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Due Date: ${_dueDate.toLocal().toString().split(' ')[0]}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              20), // Makes the button rectangular
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32.0, vertical: 16.0), // Adjust padding
                        backgroundColor:
                            const Color.fromARGB(255, 112, 191, 254),
                      ),
                      onPressed: () => _selectDueDate(context),
                      child: const Text(
                        "Select Date",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          20), // Makes the button rectangular
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 16.0), // Adjust padding
                    backgroundColor: const Color.fromARGB(255, 112, 191, 254),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      final task = Task(
                        id: widget.task?.id,
                        title: _title,
                        description: _description,
                        priority: _priority,
                        dueDate: _dueDate,
                      );
                      if (widget.task == null) {
                        Provider.of<TaskProvider>(context, listen: false)
                            .addTask(task, context);
                      } else {
                        Provider.of<TaskProvider>(context, listen: false)
                            .updateTask(task, context);
                      }
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    widget.task == null ? 'Add' : 'Update',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
