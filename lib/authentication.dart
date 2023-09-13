import 'package:firebase_auth/firebase_auth.dart';

// Sign up a new user
Future<void> signUpWithEmailAndPassword(String nom, String prenom, String adresse, String telephone, String email, String password) async {
  try {
      nom: nom;
      prenom: prenom;
      adresse: adresse;
      telephone: telephone;
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  } catch (e) {
    // Handle errors (e.g., email already exists)
    print('Error: $e');
  }
}

// Sign in an existing user
Future<void> signInWithEmailAndPassword(String email, String password) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  } catch (e) {
    // Handle errors (e.g., invalid credentials)
    print('Error: $e');
  }
}

// Sign out the current user
Future<void> signOut() async {
  await FirebaseAuth.instance.signOut();
}

// Check if a user is authenticated
User? getCurrentUser() {
  return FirebaseAuth.instance.currentUser;
}
