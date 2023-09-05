import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(MaterialApp(
    home: ModifierMotDePasseView(),
  ));
}

class ModifierMotDePasseView extends StatefulWidget {
  @override
  _ModifierMotDePasseViewState createState() => _ModifierMotDePasseViewState();
}

class _ModifierMotDePasseViewState extends State<ModifierMotDePasseView> {
  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmNewPasswordController = TextEditingController();

  String currentPasswordErrorMessage = '';
  String newPasswordErrorMessage = '';
  String confirmNewPasswordErrorMessage = '';

  final _auth = FirebaseAuth.instance;

  bool arePasswordsMatching() {
    return _newPasswordController.text == _confirmNewPasswordController.text;
  }

  bool isButtonEnabled() {
    return _currentPasswordController.text.isNotEmpty &&
        _newPasswordController.text.isNotEmpty &&
        _confirmNewPasswordController.text.isNotEmpty &&
        arePasswordsMatching();
  }

  void updateErrorMessages() {
    setState(() {
      if (_currentPasswordController.text.isEmpty) {
        currentPasswordErrorMessage =
            'Veuillez entrer votre mot de passe actuel.';
      } else {
        currentPasswordErrorMessage = '';
      }

      if (_newPasswordController.text.isEmpty) {
        newPasswordErrorMessage = 'Veuillez entrer votre nouveau mot de passe.';
      } else {
        newPasswordErrorMessage = '';
      }

      if (_confirmNewPasswordController.text.isEmpty) {
        confirmNewPasswordErrorMessage =
            'Veuillez confirmer votre nouveau mot de passe.';
      } else {
        confirmNewPasswordErrorMessage = '';
      }
    });
  }

  Future<void> updatePassword() async {
    try {
      // Réauthentifier l'utilisateur avec son mot de passe actuel
      final user = _auth.currentUser;
      final credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: _currentPasswordController.text,
      );
      await user.reauthenticateWithCredential(credential);

      // Mettre à jour le mot de passe
      await user.updatePassword(_newPasswordController.text);

      // Mot de passe mis à jour avec succès
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mot de passe mis à jour avec succès.'),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        // Le mot de passe actuel est incorrect
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Le mot de passe actuel est incorrect.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    updateErrorMessages();

    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier le mot de passe'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _currentPasswordController,
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    labelText: 'Mot de passe actuel',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _newPasswordController,
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    labelText: 'Nouveau mot de passe',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _confirmNewPasswordController,
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    labelText: 'Confirmation du nouveau mot de passe',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                if (currentPasswordErrorMessage.isNotEmpty)
                  Text(currentPasswordErrorMessage,
                      style: TextStyle(color: Colors.red)),
                if (newPasswordErrorMessage.isNotEmpty)
                  Text(newPasswordErrorMessage,
                      style: TextStyle(color: Colors.red)),
                if (confirmNewPasswordErrorMessage.isNotEmpty)
                  Text(
                    confirmNewPasswordErrorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                SizedBox(height: 20),
              ],
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Logique pour modifier le mot de passe
                        if (isButtonEnabled()) {
                          updatePassword();
                        }
                      },
                      child: Text('Modifier le mot de passe'),
                      style: ElevatedButton.styleFrom(
                        primary: isButtonEnabled()
                            ? const Color(0xFF714DD8)
                            : Colors.grey,
                        onPrimary: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
