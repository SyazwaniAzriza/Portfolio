import 'package:code/favourite.dart';
import 'package:code/history.dart';
import 'package:code/homepage.dart';
import 'package:code/translationPage.dart';
import 'package:flutter/material.dart';

class NavigationWidget extends StatefulWidget {
  const NavigationWidget({Key? key}) : super(key: key);

  @override
  _NavigationWidget createState() => _NavigationWidget();
}

class _NavigationWidget extends State<NavigationWidget> {
  int _selectedIndex = 0;

  final List<Map<String, String>> _translationHistory = [];
  final List<Map<String, String>> _savedTranslations = [];

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      TranslationPage(translationHistory: _translationHistory, savedTranslations: _savedTranslations),
      History(translationHistory: _translationHistory, savedTranslations: _savedTranslations,),
      SavedPage(savedTranslations: _savedTranslations, translationHistory: _translationHistory,),
      Homepage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.black,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.code),
            label: 'Translate',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Homepage',
          ),
        ],
      ),
    );
  }
}

