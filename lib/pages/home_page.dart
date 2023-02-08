import 'package:flutter/material.dart';
import 'package:stable_horde_flutter/pages/home/dream_tab.dart';
import 'package:stable_horde_flutter/pages/home/my_art_tab.dart';
import 'package:stable_horde_flutter/pages/settings_page.dart';
import 'package:stable_horde_flutter/widgets/glassmorphic_background.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _pageController = PageController();
  int _selectedPage = 0;

  @override
  void initState() {
    super.initState();

    homeController._animateToPageCallback = (page) {
      _pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    };
    homeController._context = context;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const GlassmorphicBackground(),
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text('Stable Horde'),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      settings: const RouteSettings(name: "SettingsPage"),
                      builder: (c) => const SettingsPage(),
                    ),
                  );
                },
              ),
            ],
          ),
          backgroundColor: Colors.transparent,
          body: _body(),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: const Color(0x9454545B),
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.draw),  
                label: 'Dream',


              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                label: 'My Art',
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
      ],
    );
  }

  Widget _body() {
    return PageView(
      controller: _pageController,
      children: const [
        DreamTab(),
        MyArtTab(),
      ],
      onPageChanged: (page) {
        setState(() {
          _selectedPage = page;
        });
      },
    );
  }
}

class _HomeController {
  void Function(int)? _animateToPageCallback;
  BuildContext? _context;

  void animateToPage(int page) {
    final callback = _animateToPageCallback;
    if (callback != null) {
      callback(page);
    }
  }

  BuildContext context() {
    return _context!;
  }
}

final homeController = _HomeController();
