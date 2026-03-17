import 'package:flutter/material.dart';
import 'package:scrum_app/view_model/login_vm.dart';
import 'package:provider/provider.dart';
import 'package:scrum_app/view/login.dart';
import '../view/home.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    // listen to LoginVM so UI updates when profile data loads/changes
    final vm = Provider.of<LoginVM>(context);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 228, 228, 228),
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // If you want to go back to Home always:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const Home()),
            );
            // If you want to just go back to previous screen:
            // Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height:  22),
            // Profile photo with fallback
            Consumer<LoginVM>(
                builder: (context, vm, child) {
                  final photo = vm.profilePhoto;

                  return photo != null && photo.isNotEmpty
                      ? ClipOval(
                          child: Image.network(
                            photo,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => const CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.transparent,
                              child: Icon(Icons.person, size: 20, color: Colors.grey),
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

            const SizedBox(height: 15),

            // Display name
            Text(
              vm.displayName ?? 'User',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            // Email
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
               width: MediaQuery.of(context).size.width * 0.7,
              padding: const EdgeInsets.all(10.0),
              child: Center( child: Text(vm.email ?? ''),
            ),),

            const SizedBox(height: 20),

            // Logout button
            GestureDetector( child:
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 221, 1, 1),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 238, 238, 238).withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              width: MediaQuery.of(context).size.width * 0.7,
              padding: const EdgeInsets.all(10.0),
              child: Center( child: Text("Logout",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  )),),
            ),
            onTap: () async {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          vm.logout();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const Login()),
                          );
                        },
                        child: const Text('Logout'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(ctx); // just close dialog
                        },
                        child: const Text('Cancel'),
                      ),
                    ],
                  ),
                );
              },
        ),
            
          ],
        ),
      ),
    );
  }
}