import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../view/home.dart';
import '../view_model/login_vm.dart';
import '../view_model/new_task.dart';

class AddStatusPage extends StatefulWidget {
  final String? initialTask;
  final String? initialStatus;
  final int? initialRating;
  final bool showRating;
  final Map<String, dynamic>? existingTask;

  const AddStatusPage({
    super.key,
    this.initialTask,
    this.initialStatus,
    this.initialRating,
    this.showRating = false,
    this.existingTask,
  });

  @override
  State<AddStatusPage> createState() => _AddStatusPageState();
}

class _AddStatusPageState extends State<AddStatusPage> {
  final TextEditingController taskController = TextEditingController();

  String selectedStatus = "Processing";
  int rating = 0;

  final List<String> statusList = ["Hold", "Processing", "Completed"];

  String generateTaskId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final rnd = Random();
    return String.fromCharCodes(
      Iterable.generate(16, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))),
    );
  }
@override
Widget build(BuildContext context) {
  final loginVM = Provider.of<LoginVM>(context, listen: false);

  // initialize fields from widget params
  if (widget.initialTask != null && taskController.text.isEmpty) {
    taskController.text = widget.initialTask!;
  }
  if (widget.initialStatus != null) {
    selectedStatus = widget.initialStatus!;
  }
  if (widget.initialRating != null) {
    rating = widget.initialRating!;
  }

  return Scaffold(
    backgroundColor: const Color(0xFFF2F2F2),
    appBar: AppBar(
      title: const Text("Add Status"),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const Home()),
          );
        },
      ),
    ),
    body: Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // MAIN CARD
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // TASK LABEL
                        const Text(
                          "Add Your Tasks",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // TASK INPUT
                        TextField(
                          controller: taskController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: "Enter your task",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // STATUS LABEL
                        const Text(
                          "Select your status",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // STATUS DROPDOWN
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedStatus,
                              isExpanded: true,
                              items: statusList
                                  .map(
                                    (s) => DropdownMenuItem(
                                      value: s,
                                      child: Text(s),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (v) => setState(() => selectedStatus = v!),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Fixed bottom area with rating and submit
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // HAPPINESS RATING (show only when requested)
                if (widget.showRating) ...[
                  const Text(
                    "Happiness Rating",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (i) {
                      return IconButton(
                        icon: Icon(
                          i < rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 28,
                        ),
                        onPressed: () => setState(() => rating = i + 1),
                      );
                    }),
                  ),
                ],

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D6EFD),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
                      final FirebaseAuth _auth = FirebaseAuth.instance;
                      final user = _auth.currentUser;
                      if (user == null) return;
                      if (taskController.text.trim().isEmpty) return;

                      // Update provider-backed task model and save to Firestore
                      final userTask = Provider.of<UserTask>(context, listen: false);
                      userTask.updateTask(taskController.text.trim(), selectedStatus, rating);
                      try {
                        await userTask.saveTask(existingTask: widget.existingTask);
                      } catch (e) {
                        // ignore save errors for now, could show snackbar
                      }

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const Home()),
                      );
                    },
                    child: const Text(
                      "Submit",
                      style: TextStyle(fontSize: 16,color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
}