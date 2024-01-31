import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:swafe/DS/colors.dart';
import 'package:swafe/blocs/auth_bloc/auth_bloc.dart';
import 'package:swafe/blocs/auth_bloc/auth_state.dart';
import 'package:swafe/components/SnackBar/snackbar.dart';
import 'package:swafe/components/appbar/appbar.dart';
import 'package:swafe/views/auth/register/3_identity_form_view.dart';
import 'package:swafe/views/auth/register/2_name_form_view.dart';
import 'package:swafe/views/auth/register/1_register_form_view.dart';

class RegistrationData {
  String email;
  String password;
  String phoneNumber;
  String phoneCountryCode;

  RegistrationData({
    this.email = '',
    this.password = '',
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
        );
      case 2:
        return NameForm(
          registrationData: registrationData,
          backPageLogic: backPageLogic,
          nextStep: nextStep,
        );
      case 3:
        return IdentityForm(
          backPageLogic: backPageLogic,
          nextStep: nextStep,
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
            SnackBar(
              content: CustomSnackbar(
                isError: true,
                label: state.message ?? 'Une erreur est survenu',
              ),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height - 160,
                  right: 20,
                  left: 20),
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
