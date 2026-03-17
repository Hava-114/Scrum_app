import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserTask extends ChangeNotifier {
  String? taskDescription;
  String? status;
  int? happinessRating;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserTask({
    this.taskDescription,
    this.status,
    this.happinessRating,
  });

  void updateTask(String description, String status, int rating) {
    taskDescription = description;
    this.status = status;
    happinessRating = rating;
    notifyListeners();
  }

  /// 🔹 Add task to Firestore (grouped per user)
  /// Save task. If [existingTask] is provided, it will be replaced.
  Future<void> saveTask({Map<String, dynamic>? existingTask}) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final docRef = _firestore.collection('tasks').doc(user.email);

    final taskData = {
      'taskId': DateTime.now().millisecondsSinceEpoch.toString(),
      'task': taskDescription,
      'status': status,
      'rating': happinessRating,
      'date': DateTime.now().toIso8601String(),
    };

    // If editing, remove the old task then add the new one.
    if (existingTask != null) {
      try {
        await docRef.update({
          'tasks': FieldValue.arrayRemove([existingTask]),
        });
      } catch (e) {
        // ignore if remove fails (e.g., task not found)
      }
    }

    await docRef.set(
      {
        'username': user.displayName ?? '',
        'email': user.email ?? '',
        'photoUrl': user.photoURL ?? '',
        'tasks': FieldValue.arrayUnion([taskData]),
      },
      SetOptions(merge: true),
    );
  }

  /// 🔹 Fetch tasks of current user
  Future<List<Map<String, dynamic>>> fetchTasks() async {
    final user = _auth.currentUser;
    if (user == null) return [];

    final doc =
        await _firestore.collection('tasks').doc(user.email).get();

    if (!doc.exists) return [];

    final data = doc.data();
    return List<Map<String, dynamic>>.from(data?['tasks'] ?? []);
  }

  /// 🔹 Delete a specific task
  Future<void> deleteTask(Map<String, dynamic> task) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('tasks').doc(user.email).update({
      'tasks': FieldValue.arrayRemove([task]),
    });
  }

  /// 🔹 Clear all tasks of user
  Future<void> clearAllTasks() async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('tasks').doc(user.email).update({
      'tasks': [],
    });
  }
}
