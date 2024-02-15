import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swafe/DS/colors.dart';
import 'package:swafe/DS/typographies.dart';
import 'package:swafe/blocs/auth_bloc/auth_bloc.dart';
import 'package:swafe/blocs/auth_bloc/auth_event.dart';
import 'package:swafe/blocs/auth_bloc/auth_state.dart';
import 'package:swafe/components/AppBar/appbar.dart';
import 'package:swafe/components/Button/button.dart';
import 'package:swafe/components/SnackBar/snackbar.dart';
import 'package:swafe/components/TextField/textfield.dart';
import 'package:swafe/helper/format_phone_number.dart';
import 'package:swafe/models/user/user_model.dart';
import 'package:swafe/views/main/tabs_available/profil/user_info/change_email_view.dart';
import 'package:swafe/views/main/tabs_available/profil/user_info/change_phone_number_view.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  UserProfileScreenState createState() => UserProfileScreenState();
}

class UserProfileScreenState extends State<UserProfileScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late UserModel user;

  @override
  void initState() {
    super.initState();
    user = context.read<AuthBloc>().user!;
    firstNameController = TextEditingController(text: user.firstName);
    lastNameController = TextEditingController(text: user.lastName);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  void updateUserData() {
    if (formKey.currentState!.validate()) {
      BlocProvider.of<AuthBloc>(context).add(
        UpdateUserEvent(
          firstName: firstNameController.text.trim(),
          lastName: lastNameController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is UpdateUserSuccess) {
          // Update user information to render
          setState(() {
            user = context.read<AuthBloc>().user!;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: CustomSnackbar(
                label: 'Vos informations ont été mises à jour.',
              ),
            ),
          );
        }
        if (state is UpdateUserError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: CustomSnackbar(
                isError: true,
                label: state.message,
              ),
            ),
          );
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
                  'Modifier vos informations',
                  style: TitleLargeMedium,
                ),
                const SizedBox(height: 24),
                Column(
                  children: [
                    CustomTextField(
                      placeholder: 'Prénom',
                      controller: firstNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer un prénom';
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
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
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
                                user.email,
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
                                  builder: (context) => ChangeEmail(
                                    email: user.email,
                                  ),
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
                                '+${user.phoneCountryCode ?? '00'} ${formatPhoneNumber(user.phoneNumber)}',
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
                                  builder: (context) => ChangePhoneNumber(
                                    phoneNumber: user.phoneNumber,
                                  ),
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
                      child: Opacity(
                        opacity: 0.4,
                        child: IgnorePointer(
                          ignoring: true,
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
                                    '/',
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
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                CustomButton(
                  isLoading:
                      context.watch<AuthBloc>().state is UpdateUserLoading,
                  label: "Modifier",
                  onPressed: () => updateUserData(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
