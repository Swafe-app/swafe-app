import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swafe/DS/colors.dart';
import 'package:swafe/DS/typographies.dart';
import 'package:swafe/components/AppBar/appbar.dart';
import 'package:swafe/components/Button/button.dart';
import 'package:swafe/components/TextField/textfield.dart';
import 'package:swafe/views/MainView/MainViewContent/profil/ChangeUserInformation/ChangeEmail.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  UserProfileScreenState createState() => UserProfileScreenState();
}

class UserProfileScreenState extends State<UserProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  String? email;
  String? phoneNumber;
  bool isLoading = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void loadUserData() async {
    setState(() => isLoading = true);
    try {
      var user = FirebaseAuth.instance.currentUser;
      var userData = await getUserData(user!.uid);
      setState(() {
        firstNameController.text = userData['firstName'] ?? '';
        lastNameController.text = userData['lastName'] ?? '';
        email = user.email ?? '-';
        phoneNumber = user.phoneNumber ?? '-';
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<Map<String, dynamic>> getUserData(String userId) async {
    var doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return doc.data() ?? {};
  }

  Future<void> updateUserData(
      String userId, String firstName, String lastName) async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({
          'firstName': firstName,
          'lastName': lastName,
        });
        // Afficher un message de succès
      } catch (e) {
        // Afficher un message d'erreur
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const CustomAppBar(),
              const SizedBox(height: 24),
              Text(
                'Modifier vos informations',
                style: TitleLargeMedium,
              ),
              const SizedBox(height: 24),
              isLoading
                  ? const CircularProgressIndicator()
                  : Column(
                      children: [
                        CustomTextField(
                          placeholder: 'Prénom',
                          controller: firstNameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer un prénom';
                            }
                            if (!RegExp(r'^[a-zA-ZÀ-ÿ\s-]+$').hasMatch(value)) {
                              return 'Seules les lettres sont autorisées';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        CustomTextField(
                          placeholder: 'Nom',
                          controller: lastNameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer un nom';
                            }
                            if (!RegExp(r'^[a-zA-ZÀ-ÿ\s-]+$').hasMatch(value)) {
                              return 'Seules les lettres sont autorisées';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                width: 1,
                                color: MyColors.neutral70,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'E-mail',
                                    style: TitleSmallMedium,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    email ?? '-',
                                    style: TitleSmallMedium.copyWith(
                                      color: MyColors.neutral40,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 20),
                              CustomButton(
                                type: ButtonType.text,
                                label: 'Modifier',
                                mainAxisSize: MainAxisSize.min,
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ChangeEmail(email: email),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                width: 1,
                                color: MyColors.neutral70,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Numéro de téléphone',
                                    style: TitleSmallMedium,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    phoneNumber ?? '-',
                                    style: TitleSmallMedium.copyWith(
                                      color: MyColors.neutral40,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 20),
                              CustomButton(
                                type: ButtonType.text,
                                label: 'Modifier',
                                mainAxisSize: MainAxisSize.min,
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const UserProfileScreen(),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                width: 1,
                                color: MyColors.neutral70,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Pièce d’identité',
                                    style: TitleSmallMedium,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Fournie',
                                    style: TitleSmallMedium.copyWith(
                                      color: MyColors.neutral40,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 20),
                              const CustomButton(
                                type: ButtonType.text,
                                label: 'Supprimer',
                                mainAxisSize: MainAxisSize.min,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
              const Spacer(),
              CustomButton(
                label: "Modifier",
                onPressed: () {
                  updateUserData(
                    FirebaseAuth.instance.currentUser!.uid,
                    firstNameController.text.trim(),
                    lastNameController.text.trim(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
