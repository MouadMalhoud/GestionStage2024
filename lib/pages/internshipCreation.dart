import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(InternshipCreation());
}

class InternshipCreation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ajout de stage',
      home: InternshipCreationScreen(),
    );
  }
}

class InternshipCreationScreen extends StatefulWidget {
  @override
  _InternshipCreationScreenState createState() =>
      _InternshipCreationScreenState();
}

class _InternshipCreationScreenState extends State<InternshipCreationScreen> {
  final TextEditingController nomStageController = TextEditingController();
  final TextEditingController donneurStageController = TextEditingController();
  final TextEditingController dateStageController = TextEditingController();
  final TextEditingController descriptionStageController =
      TextEditingController();

  late DateTime selectedDate;
  bool _isAddingStage = false; // État de l'ajout du stage

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
        dateStageController.text = formattedDate;
      });
    }
  }

  Future<void> addStage() async {
    setState(() {
      _isAddingStage = true; // Début de l'ajout du stage
    });

    try {
      await FirebaseFirestore.instance.collection('stages').add({
        'nom': nomStageController.text,
        'donneur': donneurStageController.text,
        'date': dateStageController.text,
        'description': descriptionStageController.text,
      });

      // Réinitialiser les champs du formulaire après l'ajout
      nomStageController.clear();
      donneurStageController.clear();
      dateStageController.clear();
      descriptionStageController.clear();

      // Afficher un message à l'utilisateur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Le stage a été ajouté avec succès!'),
        ),
      );
    } catch (e) {
      // Gérer les erreurs d'ajout ici
      print('Erreur lors de l\'ajout du stage: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de l\'ajout du stage.'),
        ),
      );
    } finally {
      setState(() {
        _isAddingStage = false; // Fin de l'ajout du stage
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un stage'),
      ),
      body: Center(
        child: Container(
          width: 400.0, // Largeur du Container
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: nomStageController,
                decoration: InputDecoration(labelText: 'Poste du stagiaire : '),
              ),
              TextFormField(
                controller: donneurStageController,
                decoration: InputDecoration(labelText: 'Compagnie : '),
              ),
              TextFormField(
                controller: dateStageController,
                decoration: InputDecoration(labelText: 'Date du stage'),
                onTap: () => _selectDate(context),
              ),
              TextFormField(
                controller: descriptionStageController,
                decoration: InputDecoration(
                    labelText: 'Description des tâches :'),
                maxLines: 3,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isAddingStage ? null : addStage, // Désactiver le bouton pendant l'ajout
                child: Text('Ajouter le stage'),
              ),
              SizedBox(height: 16),
              StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('stages').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  var stages = snapshot.data!.docs;
                  return Text('Nombre de stages publiés: ${stages.length}');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
