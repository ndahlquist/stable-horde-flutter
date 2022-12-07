import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stable_horde_flutter/colors.dart';
import 'package:stable_horde_flutter/pages/home/dream_tab.dart';
import 'package:stable_horde_flutter/pages/home/my_art_tab.dart';
import 'package:stable_horde_flutter/pages/settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _pageController = PageController();
  int _selectedPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: zoomscrollerGrey,
          title: const Text('ZoomScroller'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (c) => const SettingsPage(),
                  ),
                );
              },
            ),
          ],
        ),
        backgroundColor: zoomscrollerPurple,
        body: _body(),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: zoomscrollerGrey,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'My Art',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              label: 'Dream',
            ),
          ],
          currentIndex: _selectedPage,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white54,
          onTap: (i) {
            _pageController.animateToPage(
              i,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
        ),
      ),
    );
  }

  Widget _body() {
    return PageView(
      controller: _pageController,
      children: const [
        MyArtTab(),
        DreamTab(),
      ],
      onPageChanged: (page) {
        setState(() {
          _selectedPage = page;
        });
      },
    );
  }
}
