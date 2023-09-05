import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ModifierCoordonnees extends StatefulWidget {
  @override
  _ModifierCoordonneesState createState() => _ModifierCoordonneesState();
}

class _ModifierCoordonneesState extends State<ModifierCoordonnees>
    with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _currentUser;
  String _telephone = "";
  String _email = "";

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser;
    _loadUserData();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _loadUserData() async {
    if (_currentUser != null) {
      final userData =
          await _firestore.collection('users').doc(_currentUser!.uid).get();

      if (userData.exists) {
        setState(() {
          _telephone = userData['telephone'];
          _email = userData['email'];
        });
      }
    }
  }

  Future<void> _updateUserData() async {
    if (_currentUser != null) {
      try {
        // Mettre à jour l'e-mail dans Firebase Authentication
        await _currentUser!.updateEmail(_email);

        // Mettre à jour les données dans Firestore
        await _firestore.collection('users').doc(_currentUser!.uid).update({
          'telephone': _telephone,
          'email': _email,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Vos informations ont été mises à jour.'),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Erreur lors de la mise à jour des informations : $e'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier vos informations'),
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'Email'),
              Tab(text: 'Téléphone'),
            ],
            indicatorColor: Color(0xFF714DD8), // Customize the underline color
            labelColor: Color(0xFF002B5D), // Text color for the selected tab
            unselectedLabelColor:
                Color(0xFF71787E), // Text color for unselected tabs
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Email Tab
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        decoration: InputDecoration(labelText: 'Email'),
                        onChanged: (value) {
                          setState(() {
                            _email = value;
                          });
                        },
                        // Set the initial value to the user's email
                        controller: TextEditingController(
                            text: _email.isNotEmpty
                                ? _email
                                : _currentUser?.email),
                      ),
                      ElevatedButton(
                        onPressed: _updateUserData,
                        child: Text('Envoyer'),
                      ),
                    ],
                  ),
                ),
                // Téléphone Tab
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        decoration: InputDecoration(labelText: 'Téléphone'),
                        onChanged: (value) {
                          setState(() {
                            _telephone = value;
                          });
                        },
                        // Set the initial value from Firestore
                        controller: TextEditingController(text: _telephone),
                      ),
                      ElevatedButton(
                        onPressed: _updateUserData,
                        child: Text('Envoyer'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
