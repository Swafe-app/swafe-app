import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swafe/DS/colors.dart';
import 'package:swafe/DS/spacing.dart';
import 'package:swafe/DS/typographies.dart';
import 'package:swafe/blocs/auth_bloc/auth_bloc.dart';
import 'package:swafe/blocs/auth_bloc/auth_state.dart';
import '../main/MainViewContent/home/homecontent.dart';
import 'profil.dart';
import 'repertoire.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomNavbar();
  }
}

class CustomNavbar extends StatefulWidget {
  const CustomNavbar({super.key});

  @override
  State<CustomNavbar> createState() => _CustomNavbarState();
}

class _CustomNavbarState extends State<CustomNavbar> {
  int activeNavIndex = 1;

  Widget renderActiveIndexNavbar() {
    switch (activeNavIndex) {
      case 1:
        return const HomeContent();
      case 2:
        return const RepertoireContent();
      case 3:
        return const ProfilContent();
      default:
        return const HomeContent();
    }
  }

  Widget navbarItemButton(
      {required int index, required String label, required IconData iconData}) {
    return InkResponse(
      onTap: activeNavIndex == index
          ? null
          : () => setState(() {
                activeNavIndex = index;
              }),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(iconData,
              size: 32,
              color: activeNavIndex == index
                  ? MyColors.secondary40
                  : MyColors.neutral70),
          if (activeNavIndex == index) ...[
            const SizedBox(height: 2),
            Container(
              height: 4,
              width: 4,
              decoration: BoxDecoration(
                  color: activeNavIndex == index
                      ? MyColors.secondary40
                      : MyColors.neutral70,
                  shape: BoxShape.circle),
            ),
            const SizedBox(height: 2),
          ] else
            const SizedBox(height: 8),
          Text(
            label,
            style: LabelMediumRegular.copyWith(
              color: activeNavIndex == index
                  ? MyColors.secondary40
                  : MyColors.neutral70,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          Navigator.of(context).pushReplacementNamed('/home');
        }
      },
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: Stack(
            children: [
              Positioned.fill(
                child: Center(
                  child: renderActiveIndexNavbar(),
                ),
              ),
              Positioned(
                left: Spacing.medium,
                right: Spacing.medium,
                bottom: Spacing.medium,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 16.0,
                  ),
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.15),
                        offset: Offset(0, 2), // Horizontal, Vertical
                        blurRadius: 6,
                        spreadRadius: 2,
                      ),
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.30),
                        offset: Offset(0, 1), // Horizontal, Vertical
                        blurRadius: 2,
                        spreadRadius: 0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(16),
                    color: MyColors.neutral90,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      navbarItemButton(
                        index: 1,
                        label: "Home",
                        iconData: Icons.home_outlined,
                      ),
                      navbarItemButton(
                        index: 2,
                        label: "Répertoire",
                        iconData: Icons.phone_outlined,
                      ),
                      navbarItemButton(
                        index: 3,
                        label: "Profil",
                        iconData: Icons.person_outline,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
