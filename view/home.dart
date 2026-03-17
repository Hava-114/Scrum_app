import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrum_app/model/individual_task.dart';
import 'package:url_launcher/url_launcher.dart';
import '../view/newtask.dart';
import '../view/profile.dart';
import '../view_model/login_vm.dart';
import '../view_model/home_vm.dart';

class Home extends StatelessWidget {
  const Home({super.key});
Future<void> _sendToWhatsApp(String message) async {
  final encodedMessage = Uri.encodeComponent(message);
  final url = Uri.parse("https://wa.me/?text=$encodedMessage");

  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {
    debugPrint("Could not open WhatsApp");
  }
}
  @override
  Widget build(BuildContext context) {
    final homeVM = Provider.of<HomeVm>(context, listen: true);

    return Scaffold(
      backgroundColor:  const Color(0xFFF2F2F2),

      appBar: AppBar(
        title: const Text('Scrum Status'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const Profile()),
                );
              },
              child: Consumer<LoginVM>(
                builder: (context, vm, child) {
                  final photo = vm.profilePhoto;

                  return photo != null && photo.isNotEmpty
                      ? ClipOval(
                          child: Image.network(
                            photo,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.transparent,
                              ),
                              child: const Icon(Icons.person, size: 20, color: Colors.grey),
                            ),
                          ),
                        )
                      : const CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.grey,
                          child: Icon(Icons.person, size: 20, color: Colors.white),
                        );
                },
              ),
            ),
          ),
        ],
      ),

      body: Column(
        children: [
          // Header showing signed-in user's name and photo from LoginVM
          

          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: homeVM.fetchTasks(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No tasks found"));
                }

                final taskList = snapshot.data!;
// ...existing code...
                return Container(
                  decoration: const BoxDecoration(
                    color: const Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: ListView.builder(
  itemCount: taskList.length,
  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
  itemBuilder: (context, index) {
    final task = taskList[index];

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
          trailing: const Icon(Icons.keyboard_arrow_down),
          title: Row(
            children: [
              
              ClipOval(
                child: Image.network(
                  task.photoUrl ?? '',
                  width: 36,
                  height: 36,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person, size: 18, color: Colors.grey),
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              Text(
                task.name ?? 'No Name',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          
          // 🔽 DROPDOWN CONTENT (TASKS)
          children:

          task.tasks != null && task.tasks!.isNotEmpty
              ? task.tasks!.map<Widget>((t) {
                  // determine if t is a map (saved task) or a simple string
                  final String taskText = (t is Map && t['task'] != null) ? t['task'].toString() : t.toString();
                  final int taskRating = (t is Map && t['rating'] != null) ? (t['rating'] as int) : 0;
                  final String taskStatus = (t is Map && t['status'] != null) ? t['status'].toString() : 'Processing';
                  final Map<String, dynamic>? existing = t is Map ? Map<String, dynamic>.from(t) : null;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 6),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddStatusPage(
                              initialTask: taskText,
                              initialStatus: taskStatus,
                              initialRating: taskRating,
                              showRating: true,
                              existingTask: existing,
                            ),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              taskText,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList()
              : [
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      "No tasks available",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
        ),
      ),
    );
  },
),

                );
// ...existing code...
                
              },
            ),
          ),
        ],
      ),

      bottomNavigationBar: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const AddStatusPage()),
              );
            },
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              "Add Status",
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

