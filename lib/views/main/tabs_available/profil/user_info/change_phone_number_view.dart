import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:swafe/DS/typographies.dart';
import 'package:swafe/blocs/auth_bloc/auth_bloc.dart';
import 'package:swafe/blocs/auth_bloc/auth_event.dart';
import 'package:swafe/blocs/auth_bloc/auth_state.dart';
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
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();
  String countryCode = '33';

  @override
  void initState() {
    super.initState();
    phoneController.text = widget.phoneNumber ?? '';
  }

  Future<void> updateUserPhoneNumber() async {
    if (formKey.currentState!.validate()) {
      BlocProvider.of<AuthBloc>(context).add(
        UpdateUserEvent(
          phoneNumber: phoneController.text.trim(),
          phoneCountryCode: countryCode,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is UpdateUserSuccess) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const CustomAppBar(),
                const SizedBox(height: 24),
                Text(
                  'Modifier votre numéro de  téléphone',
                  style: TitleLargeMedium,
                ),
                const SizedBox(height: 24),
                IntlPhoneField(
                  controller: phoneController,
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
                  isLoading:
                      context.watch<AuthBloc>().state is UpdateUserLoading,
                  label: "Modifier",
                  onPressed: updateUserPhoneNumber,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
