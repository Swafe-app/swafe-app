import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

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
          _nameController.text = _name;
          _lastNameController.text = _lastName;
        });
      }
    }
  }

  Future<void> _updateUserData() async {
    if (_currentUser != null) {
      final userDoc = _firestore.collection('users').doc(_currentUser!.uid);
      final docSnapshot = await userDoc.get();

      if (docSnapshot.exists) {
        try {
          await userDoc.update({
            'name': _nameController.text,
            'lastName': _lastNameController.text,
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
      } else {
        try {
          await userDoc.set({
            'name': _nameController.text,
            'lastName': _lastNameController.text,
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Nouveau document utilisateur créé.'),
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur lors de la création du document.'),
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier vos informations'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Nom'),
              controller: _nameController,
              onChanged: (value) {
                setState(() {
                  _name = value;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Prénom'),
              controller: _lastNameController,
              onChanged: (value) {
                setState(() {
                  _lastName = value;
                });
              },
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
