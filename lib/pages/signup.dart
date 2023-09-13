import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart'; // Import your login screen
import 'home.dart'; // Import Firebase Authentication
import '../authentication.dart';

class Signup extends StatefulWidget {
  Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController nomController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController adresseController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();

  final TextEditingController nomEntrepriseController = TextEditingController();
  final TextEditingController prenomPersonneContactController = TextEditingController();
  final TextEditingController nomPersonneContactController = TextEditingController();
  final TextEditingController posteTelephoniqueController = TextEditingController();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String selectedUserType = 'Étudiant'; // Default selected user type

  final List<String> userTypes = ['Étudiant', 'Employeur']; // Dropdown options

  Future<void> _signUp(BuildContext context) async {
    try {
      nom: nomController.text;
      prenom: prenomController.text;
      adresse: adresseController.text;
      telephone: telephoneController.text;
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // Navigate to the home screen after successful signup
      if (context.mounted) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const Home(),
        ));
      }
    } catch (e) {
      // Handle signup errors here
      print('Signup error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("S'inscrire", style: TextStyle(color: Colors.white)),
        
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
             Container(
              width: 400, // Set the desired width
              child: DropdownButtonFormField<String>(
                value: selectedUserType,
                onChanged: (newValue) {
                  setState(() {
                    selectedUserType = newValue!;
                  });
                },
                items: userTypes.map((String userType) {
                  return DropdownMenuItem<String>(
                    value: userType,
                    child: Text(userType),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Je suis un :',
                ),
              ),
            ),
            Visibility(
              visible: selectedUserType == 'Employeur',
              child: Container(
                width: 400,
                child: TextField(
                  controller: nomEntrepriseController,
                  decoration: InputDecoration(labelText: "Nom de l'entreprise"),
                  obscureText: true,
                ),
              ),
            ),
             Visibility(
              visible: selectedUserType == 'Employeur',
              child: Container(
                width: 400,
                child: TextField(
                  controller: prenomPersonneContactController,
                  decoration: InputDecoration(labelText: "Prénom de la personne responsable"),
                  obscureText: true,
                ),
              ),
            ),
             Visibility(
              visible: selectedUserType == 'Employeur',
              child: Container(
                width: 400,
                child: TextField(
                  controller: nomPersonneContactController,
                  decoration: InputDecoration(labelText: "Nom de la personne responsable"),
                  obscureText: true,
                ),
              ),
            ),
             Visibility(
              visible: selectedUserType == 'Étudiant',
              child: Container(
                width: 400,
                child: TextField(
                  controller: prenomController,
                  decoration: InputDecoration(labelText: 'Prénom'),
                  obscureText: true,
                ),
              ),
            ),
            Visibility(
              visible: selectedUserType == 'Étudiant',
              child: Container(
                width: 400,
                child: TextField(
                  controller: nomController,
                  decoration: InputDecoration(labelText: 'Nom'),
                  obscureText: true,
                ),
              ),
            ),
            Container(
              width: 400, // Set the desired width
              child: TextField(
                controller: adresseController,
                decoration: const InputDecoration(labelText: 'Adresse complète'),
              ),
            ),
             Container(
              width: 400, // Set the desired width
              child: TextField(
                controller: telephoneController,
                decoration: const InputDecoration(labelText: 'Numéro de téléphone'),
              ),
            ),
          Visibility(
              visible: selectedUserType == 'Employeur',
              child: Container(
                width: 400,
                child: TextField(
                  controller: posteTelephoniqueController,
                  decoration: InputDecoration(labelText: "Poste téléphonique"),
                  obscureText: true,
                ),
              ),
            ),

              Container(
              width: 400,
              height: 150,
              margin: EdgeInsets.only(top: 20.0),
              child: Column(
                children: [                  
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Mot de passe',
                    ),
                    obscureText: true,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () => _signUp(context),
              child: const Text("S'inscrire"),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                // Navigate to the login page when the button is pressed
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => Login(),
                ));
              },
              child: const Text('Déja inscrit(e)? Se connecter'),
            ),
          ],
        ),
      ),
    );
  }
}
