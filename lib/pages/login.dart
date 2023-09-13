import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart'; // Import your home screen
import 'signup.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? errorText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Se connecter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 250,
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: 250,
              child: TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Mot de passe',
                ),
                obscureText: true,
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () async {
                try {
                  final UserCredential userCredential =
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: emailController.text,
                    password: passwordController.text,
                  );
                  final User? user = userCredential.user;

                  if (user != null) {
                    // Valid credentials, navigate to the home screen
                    if (context.mounted) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const Home(),
                      ));
                    }
                  }
                } on FirebaseAuthException catch (e) {
                  // Handle authentication errors here
                  setState(() {
                    errorText = e.message;
                  });
                }
              },
              child: const Text('Se connecter'),
            ),
            if (errorText != null)
              Text(
                errorText!,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 16), // Add some spacing
            TextButton(
              onPressed: () {
                // Navigate to the SignupScreen when the button is pressed
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Signup(),
                  ),
                );
              },
              child: const Text("S'inscrire"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
