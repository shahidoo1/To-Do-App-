// import 'package:flutter/material.dart';
// import 'package:flutter_application_2/view/task_screen.dart';
// import 'package:flutter_application_2/viewModel/task_view_model.dart';
// import 'package:provider/provider.dart';

// class TaskScreen extends StatefulWidget {
//   @override
//   _TaskScreenState createState() => _TaskScreenState();
// }

// class _TaskScreenState extends State<TaskScreen> {
//   String _searchQuery = '';
//   final TextEditingController _searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     Provider.of<TaskProvider>(context, listen: false).loadTasks();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('To-Do App'),
//         backgroundColor: const Color.fromARGB(255, 112, 191, 254),
//       ),
//       body: Column(
//         children: [
//           // Search TextField
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.3),
//                     spreadRadius: 1,
//                     blurRadius: 2,
//                     offset: Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: TextField(
//                 controller: _searchController,
//                 onChanged: (query) {
//                   setState(() {
//                     _searchQuery = query;
//                   });
//                 },
//                 decoration: InputDecoration(
//                   hintText: 'Search',
//                   // prefixIcon: Icon(Icons.search),

//                   suffixIcon: _searchQuery.isNotEmpty
//                       ? IconButton(
//                           icon: Icon(Icons.clear),
//                           onPressed: () {
//                             setState(() {
//                               _searchController.clear();
//                               _searchQuery = '';
//                             });
//                           },
//                         )
//                       : null,
//                   border: InputBorder.none, // Remove the border
//                 ),
//               ),
//             ),
//           ),

//           Expanded(
//             child: Consumer<TaskProvider>(
//               builder: (context, taskProvider, child) {
//                 // Filter tasks based on the search query
//                 final filteredTasks = taskProvider.tasks.where((task) {
//                   return task.title
//                           .toLowerCase()
//                           .contains(_searchQuery.toLowerCase()) ||
//                       task.description
//                           .toLowerCase()
//                           .contains(_searchQuery.toLowerCase());
//                 }).toList();

//                 return ListView.builder(
//                   itemCount: filteredTasks.length,
//                   itemBuilder: (context, index) {
//                     final task = filteredTasks[index];
//                     return Container(
//                       margin: const EdgeInsets.symmetric(
//                           horizontal: 10, vertical: 6),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(15),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.2),
//                             blurRadius: 5,
//                             offset: const Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: ListTile(
//                         title: Text(task.title),
//                         subtitle: Text(
//                             'Priority: ${task.priority}, Due: ${task.dueDate.toLocal().toString().split(' ')[0]}'),
//                         trailing: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             IconButton(
//                               icon: const Icon(Icons.edit),
//                               onPressed: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => TaskForm(task: task),
//                                   ),
//                                 );
//                               },
//                             ),
//                             IconButton(
//                               icon: const Icon(Icons.delete),
//                               onPressed: () {
//                                 Provider.of<TaskProvider>(context,
//                                         listen: false)
//                                     .deleteTask(task.id!);
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: const Color.fromARGB(255, 112, 191, 254),
//         child: const Icon(Icons.add),
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => TaskForm(),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_application_2/view/task_screen.dart';
import 'package:flutter_application_2/viewModel/task_view_model.dart';
import 'package:provider/provider.dart';

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<TaskProvider>(context, listen: false).loadTasks();
  }

  // Helper function to map priority value to label
  String _getPriorityLabel(int priority) {
    switch (priority) {
      case 1:
        return 'High';
      case 2:
        return 'Medium';
      case 3:
        return 'Low';
      default:
        return 'Medium';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do App'),
        backgroundColor: const Color.fromARGB(255, 112, 191, 254),
      ),
      body: Column(
        children: [
          // Search TextField
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (query) {
                  setState(() {
                    _searchQuery = query;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search',
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                  border: InputBorder.none, // Remove the border
                ),
              ),
            ),
          ),

          Expanded(
            child: Consumer<TaskProvider>(
              builder: (context, taskProvider, child) {
                // Filter tasks based on the search query
                final filteredTasks = taskProvider.tasks.where((task) {
                  return task.title
                          .toLowerCase()
                          .contains(_searchQuery.toLowerCase()) ||
                      task.description
                          .toLowerCase()
                          .contains(_searchQuery.toLowerCase());
                }).toList();

                return ListView.builder(
                  itemCount: filteredTasks.length,
                  itemBuilder: (context, index) {
                    final task = filteredTasks[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Text(task.title),
                        subtitle: Text(
                            'Priority: ${_getPriorityLabel(task.priority)}, Due: ${task.dueDate.toLocal().toString().split(' ')[0]}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TaskForm(task: task),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                Provider.of<TaskProvider>(context,
                                        listen: false)
                                    .deleteTask(task.id!);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 112, 191, 254),
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskForm(),
            ),
          );
        },
      ),
    );
  }
}
