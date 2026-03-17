import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrum_app/view/home.dart';
import 'package:scrum_app/view/newtask.dart';
import '../view_model/login_vm.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<LoginVM>(context);
    return Scaffold(
      
      backgroundColor: const Color.fromRGBO(69, 158, 255, 1),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.23),
            Image.asset('assets/logo.png', width: 125, height: 125),
            const SizedBox(height: 10),
            const Text(
              'Yaash Scrum',
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
             SizedBox(height: MediaQuery.of(context).size.height*0.33),
            const Text(
              'Sign in With',
              style: TextStyle(fontSize: 13, color: Colors.white),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: vm.isLoading ? const Color.fromARGB(255, 228, 228, 228) : Colors.white,
                minimumSize: const Size(80, 45),
                fixedSize: const Size(500, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),)
              ),
              onPressed: vm.isLoading
                  ? null
                  : ()  async {
                      final success = await vm.signInWithGoogle();
                      if (success) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => Home()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(vm.errorMessage ?? 'Login failed'),
                          ),
                        );
                      }
                    },
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/google-icon.png',
                        width: 45, height: 45),
                    const SizedBox(width: 20),
                    Text(
                      'Google',
                      style: TextStyle(
                        color: vm.isLoading ? Colors.black54 : Colors.black,
                      ),
                    ),

                  ],
                ),
              ),
            ),
            SizedBox(height: 17),
            Text('By continuing, you agree to our teams & privacy policy',style: TextStyle(color: Colors.white,fontSize: 12),)
          ],
        ),
      ),
    );
  }
}