import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:swafe/DS/colors.dart';
import 'package:swafe/blocs/auth_bloc/auth_bloc.dart';
import 'package:swafe/blocs/auth_bloc/auth_state.dart';
import 'package:swafe/components/SnackBar/snackbar.dart';
import 'package:swafe/components/appbar/appbar.dart';
import 'package:swafe/views/auth/register/identity_form_view.dart';
import 'package:swafe/views/auth/register/name_form_view.dart';
import 'package:swafe/views/auth/register/register_form_view.dart';

class RegistrationData {
  String email;
  String password;
  String phoneNumber;
  String phoneCountryCode;

  RegistrationData({
    this.email = 'test+1@test.fr',
    this.password = 'Test1234+',
    this.phoneNumber = '',
    this.phoneCountryCode = '33',
  });
}

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  RegisterViewState createState() => RegisterViewState();
}

class RegisterViewState extends State<RegisterView> {
  final RegistrationData registrationData = RegistrationData();
  final storage = const FlutterSecureStorage();
  int activeStep = 1;
  int maxStep = 3;

  void nextStep() {
    setState(() {
      activeStep++;
    });
  }

  void previousStep() {
    setState(() {
      activeStep--;
    });
  }

  void backPageLogic() async {
    if (activeStep > 1) {
      previousStep();
    } else {
      Navigator.of(context).pop();
    }
  }

  Widget bodyBuilder() {
    switch (activeStep) {
      case 1:
        return RegisterForm(
          registrationData: registrationData,
          backPageLogic: backPageLogic,
          nextStep: nextStep,
          storage: storage,
        );
      case 2:
        return NameForm(
          registrationData: registrationData,
          backPageLogic: backPageLogic,
          nextStep: nextStep,
          storage: storage,
        );
      case 3:
        return IdentityForm(
          backPageLogic: backPageLogic,
          nextStep: nextStep,
          storage: storage,
        );
      default:
        return const CustomAppBar();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          nextStep();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  CustomSnackbar(label: "Votre compte a été créé avec succès."),
            ),
          );
        }
        if (state is RegisterError) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: CustomSnackbar(
                isError: true,
                label: "Une erreur s'est produite. Veuillez réessayer.",
              ),
            ),
          );
        }
      },
      child: Scaffold(
        bottomNavigationBar: LinearProgressIndicator(
          color: MyColors.secondary40,
          backgroundColor: MyColors.neutral90,
          value: activeStep / maxStep,
          minHeight: 18,
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: screenSize.height),
              child: WillPopScope(
                onWillPop: () async {
                  backPageLogic();
                  return false;
                },
                child: bodyBuilder(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
