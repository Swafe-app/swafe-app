import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:swafe/views/MainView/MainViewContent/profil/coordonnees.dart';
import 'package:swafe/components/appbar/custom_appbar_page.dart'; // Importez CustomAppBar

class ReauthenticationPage extends StatefulWidget {
  @override
  _ReauthenticationPageState createState() => _ReauthenticationPageState();
}

class _ReauthenticationPageState extends State<ReauthenticationPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _passwordController = TextEditingController();
  String _error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        // Utilisez CustomAppBar ici
        title: 'Réauthentification',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Mot de passe',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                final password = _passwordController.text.trim();

                // Réauthentification de l'utilisateur
                final result = await _reauthenticate(password);

                if (result) {
                  // Réauthentification réussie, naviguer vers coordonnees.dart
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => ModifierCoordonnees(),
                    ),
                  );
                } else {
                  // Réauthentification échouée, afficher un message d'erreur
                  setState(() {
                    _error = 'Mot de passe incorrect';
                  });
                }
              },
              child: Text('Valider'),
            ),
            if (_error.isNotEmpty)
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  _error,
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<bool> _reauthenticate(String password) async {
    try {
      // Obtenez l'utilisateur actuel
      User? user = _auth.currentUser;

      if (user != null) {
        // Créez des informations d'identification avec l'e-mail de l'utilisateur actuel et le mot de passe entré
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: password,
        );

        // Réauthentifiez l'utilisateur avec les informations d'identification
        await user.reauthenticateWithCredential(credential);

        return true; // Réauthentification réussie
      }
    } catch (e) {
      // Gérez les erreurs ici, par exemple, si le mot de passe est incorrect
      print(e.toString());
    }

    return false; // Réauthentification échouée
  }
}
