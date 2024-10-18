# flutter_application_2

A new Flutter project that serves as a task management application.

## Overview

This Flutter application is designed to help users manage their tasks efficiently. It includes functionalities for creating tasks, setting notifications for due dates, managing permissions, and searching for tasks.

## Getting Started

This project is a starting point for a Flutter application. Below are some resources to help you get started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the [online documentation](https://docs.flutter.dev/), which offers tutorials, samples, guidance on mobile development, and a full API reference.

## Features

- **Task Creation**: Users can create tasks with a title, description, priority, and due date.
- **Task Notifications**: Users receive notifications for tasks based on their due dates.
- **Task Search**: Easily search for tasks by title or description.
- **Task Priority**: Set a priority level for each task to help prioritize work.
- **Task Completion**: Mark tasks as completed.
- **Permissions Handling**: Requests necessary permissions for notifications.

## Technologies Used

- Flutter
- Dart
- SQLite (for local data storage)
- flutter_local_notifications (for notifications)
- permission_handler (for managing permissions)

## Installation Steps

1. Clone the repository:
   
bash
   git clone https://github.com/shahidoo1/To-Do-App-.git
   cd flutter_application_2
   flutter pub get
   flutter run

## Functionality Description
Task Class
The Task class represents a task and includes properties such as:

id: Unique identifier for the task.
title: Title of the task.
description: Detailed description of the task.
priority: Priority level of the task (e.g., low, medium, high).
dueDate: Date and time by which the task should be completed.
isCompleted: Boolean flag to indicate if the task is completed.

## Notification Handling
The app uses the flutter_local_notifications package to manage notifications. The following functions are important:

initializeNotifications: Initializes the notification plugin.
requestNotificationPermission: Requests permission to send notifications.
scheduleTaskNotification: Schedules a notification for a specific task based on its due date.
cancelTaskNotification: Cancels the notification for a task.
Search Functionality
The app implements search functionality by allowing users to filter tasks based on the query provided in the search field.

## Permissions Management
The app manages permissions for notifications and scheduling alarms:

requestNotificationPermission: Requests user permission for notifications.
checkExactAlarmPermission: Checks and requests permission for exact alarms (if applicable).

## How It Works
Task Creation: Users can create tasks with all necessary details. Each task is stored locally in SQLite.
Task Notification: When a task is created, a notification is scheduled based on the due date using the scheduleTaskNotification function.
Task Search: Users can search for tasks using the search functionality, which filters tasks as they type.
Permissions Handling: The app requests necessary permissions for notifications to ensure users receive timely alerts about their tasks.

## Usage Instructions

Creating a Task: Navigate to the task creation screen and fill in the required fields.
Viewing Tasks: All tasks will be displayed in a list format, showing their title and status.
Receiving Notifications: Notifications will be sent as per the due dates set for each task.

## Error Handling
The application includes basic error handling for:

Notification scheduling issues.
Permission denial for notifications.
Invalid task details during creation.
