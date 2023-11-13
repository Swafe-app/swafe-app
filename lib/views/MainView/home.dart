import 'package:flutter/material.dart';
import 'package:swafe/DS/spacing.dart';
import 'MainViewContent/home/homecontent.dart';
import 'repertoire.dart';
import 'profil.dart';

class HomeView extends StatelessWidget {
  final String welcomeMessage;

  const HomeView({Key? key, required this.welcomeMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const BottomNavigationBarExample();
  }
}

class BottomNavigationBarExample extends StatefulWidget {
  const BottomNavigationBarExample({Key? key}) : super(key: key);

  @override
  State<BottomNavigationBarExample> createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState
    extends State<BottomNavigationBarExample> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Center(
              child: _widgetOptions.elementAt(_selectedIndex),
            ),
          ),
          Positioned(
            left: Spacing.medium,
            right: Spacing.medium,
            bottom: Spacing.medium,
            height: 88,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
                child: BottomNavigationBar(
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.phone),
                      label: 'Répertoire',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person),
                      label: 'Profil',
                    ),
                  ],
                  currentIndex: _selectedIndex,
                  selectedItemColor: const Color(0xFF714DD8),
                  onTap: _onItemTapped,
                ),
              ),
            ),
        ],
      ),
    );
  }

  final List<Widget> _widgetOptions = <Widget>[
    const HomeContent(),
    const RepertoireContent(),
    ProfilContent(),
  ];
}