import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/individual_task.dart';
class HomeVm extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;  

  Future<List<Model>> fetchTasks() async {
    final querySnapshot = await _firestore.collection('/tasks').get();
    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return Model(
        name: data['username'] ?? '',
        email: data['email'] ?? '',
        photoUrl: data['photoUrl'] ?? '',
        tasks: data['tasks'] ?? [],
      );
    }).toList();
  }
  Future<void> saveTask() async{
     // one doc per user
    final taskData = {
       
      'email': DateTime.now().millisecondsSinceEpoch.toString(),
      'task': 'taskDescription',
      'status': 'status',
      'rating': 5,
      'date': DateTime.now().toIso8601String(),
    };
  }
}

  /// Fetch users with their tasks
  