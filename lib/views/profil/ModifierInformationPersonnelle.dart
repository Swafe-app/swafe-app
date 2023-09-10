import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swafe/DS/custom_appbar_page.dart'; // Importez CustomAppBar

class ModifierInformationPersonnelle extends StatefulWidget {
  @override
  _ModifierInformationPersonnelleState createState() =>
      _ModifierInformationPersonnelleState();
}

class _ModifierInformationPersonnelleState
    extends State<ModifierInformationPersonnelle> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _currentUser;
  String _name = "";
  String _lastName = "";

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (_currentUser != null) {
      final userData =
          await _firestore.collection('users').doc(_currentUser!.uid).get();

      if (userData.exists) {
        setState(() {
          _name = userData['name'];
          _lastName = userData['lastName'];
        });
      }
    }
  }

  Future<void> _updateUserData() async {
    if (_currentUser != null) {
      try {
        await _firestore.collection('users').doc(_currentUser!.uid).update({
          'name': _name,
          'lastName': _lastName,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Vos informations ont été mises à jour.'),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la mise à jour des informations.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        // Utilisez CustomAppBar ici
        title: 'Modifier vos informations',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Nom'),
              onChanged: (value) {
                setState(() {
                  _name = value;
                });
              },
              // Set the initial value from Firestore
              controller: TextEditingController(text: _name),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Prénom'),
              onChanged: (value) {
                setState(() {
                  _lastName = value;
                });
              },
              // Set the initial value from Firestore
              controller: TextEditingController(text: _lastName),
            ),
            ElevatedButton(
              onPressed: _updateUserData,
              child: Text('Envoyer'),
            ),
          ],
        ),
      ),
    );
  }
}
