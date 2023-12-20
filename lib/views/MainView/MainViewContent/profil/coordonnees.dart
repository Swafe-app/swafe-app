import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swafe/DS/colors.dart';
import 'package:swafe/DS/spacing.dart';
import 'package:swafe/components/Button/button.dart';

class ModifierCoordonnees extends StatefulWidget {
  const ModifierCoordonnees({super.key});

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
        await _currentUser!.updateEmail(_email);

        await _firestore.collection('users').doc(_currentUser!.uid).update({
          'telephone': _telephone,
          'email': _email,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
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
      body: Container(
        color: MyColors.defaultWhite, // Définir la couleur de fond en blanc
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.large),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Email'),
                  Tab(text: 'Téléphone'),
                ],
                indicatorColor: MyColors.secondary30,
                labelColor: MyColors.primary10,
                unselectedLabelColor: MyColors.neutral40,
                isScrollable: true,
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Email Tab
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextField(
                          decoration: const InputDecoration(labelText: 'Email'),
                          onChanged: (value) {
                            setState(() {
                              _email = value;
                            });
                          },
                          controller: TextEditingController(
                              text: _email.isNotEmpty
                                  ? _email
                                  : _currentUser?.email),
                        ),
                        SizedBox(height: 16.0),
                        CustomButton(
                          label: "Envoyer",
                          fillColor: MyColors.secondary40,
                          textColor: MyColors.defaultWhite,
                          onPressed: _updateUserData,
                        ),
                      ],
                    ),
                    // Téléphone Tab
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextField(
                          decoration:
                              const InputDecoration(labelText: 'Téléphone'),
                          onChanged: (value) {
                            setState(() {
                              _telephone = value;
                            });
                          },
                          controller: TextEditingController(text: _telephone),
                        ),
                        const SizedBox(height: 16.0),
                        CustomButton(
                          label: "Envoyer",
                          fillColor: MyColors.secondary40,
                          textColor: MyColors
                              .defaultWhite, // Set to the desired text color
                          onPressed: _updateUserData,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
