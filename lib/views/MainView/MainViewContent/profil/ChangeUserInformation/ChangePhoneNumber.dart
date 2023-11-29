import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:swafe/DS/colors.dart';
import 'package:swafe/DS/typographies.dart';
import 'package:swafe/components/AppBar/appbar.dart';
import 'package:swafe/components/Button/button.dart';
import 'package:swafe/components/TextField/textfield.dart';

class ChangePhoneNumber extends StatefulWidget {
  final String? phoneNumber;

  const ChangePhoneNumber({super.key, required this.phoneNumber});

  @override
  ChangePhoneNumberState createState() => ChangePhoneNumberState();
}

class ChangePhoneNumberState extends State<ChangePhoneNumber> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  String countryCode = '33';
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _phoneController.text = widget.phoneNumber ?? '';
  }

  Future<void> updateUserPhoneNumber() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .update({
          'phoneNumber': _phoneController.text.trim(),
          'phoneCountryCode': countryCode,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Vos informations ont été mises à jour avec succès."),
          ),
        );
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Erreur lors de la mise à jour des informations."),
          ),
        );
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
                'Modifier votre numéro de  téléphone',
                style: TitleLargeMedium,
              ),
              const SizedBox(height: 24),
              if (errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    errorMessage,
                    style: BodyLargeMedium.copyWith(color: MyColors.error40),
                  ),
                ),
              IntlPhoneField(
                controller: _phoneController,
                invalidNumberMessage: 'Entrez un numéro de téléphone valide.',
                validator: (phone) {
                  if (phone == null || phone.number.isEmpty) {
                    return 'Veuillez entrer un numéro de téléphone.';
                  }
                  return null;
                },
                onCountryChanged: (newCountryCode) {
                  setState(() {
                    countryCode = newCountryCode.dialCode;
                  });
                },
                decoration: customTextFieldDecoration.copyWith(
                    label: const Text("N° de téléphone portable")),
                initialCountryCode: 'FR',
                countries: List<Country>.of(
                    countries.where((ct) => ['FR'].contains(ct.code))),
              ),
              const Spacer(),
              CustomButton(
                label: "Modifier",
                onPressed: updateUserPhoneNumber,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
