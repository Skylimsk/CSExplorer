import 'package:csexplorer/presentation/screens/FAQ/manage_faq.dart';
import 'package:csexplorer/presentation/screens/Forum/manage_forum.dart';
import 'package:csexplorer/presentation/screens/Home/adminHome.dart';
import 'package:csexplorer/presentation/screens/Profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AdminBottomNavBar extends StatefulWidget {
  const AdminBottomNavBar({super.key});

  @override
  State<AdminBottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<AdminBottomNavBar> {
  int _currentTabBar = 0;

  final List<GlobalKey<NavigatorState>> _tabNavigators = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: _tabItems,
        activeColor: Colors.indigo[700],
        currentIndex: _currentTabBar,
        onTap: (int index) {
          if (_currentTabBar == index) {
            _popToInitialRoute(index);
          } else {
            setState(() {
              _currentTabBar = index;
            });
          }
        },
      ),
      tabBuilder: (context, index) {
        return CupertinoTabView(
            navigatorKey: _tabNavigators[index],
            builder: (context) {
              return Scaffold(
                body: _tabPages[index],
              );
            });
      },
    );
  }

  final List<BottomNavigationBarItem> _tabItems = [
    const BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
    const BottomNavigationBarItem(
        icon: Icon(Icons.question_mark_rounded), label: 'FAQ'),
    const BottomNavigationBarItem(
        icon: Icon(Icons.question_answer_rounded), label: 'Forum'),
    const BottomNavigationBarItem(
        icon: Icon(Icons.person_3_rounded), label: 'Profile')
  ];

  final List<Widget> _tabPages = [
    const Center(child: AdminHome()),
    const Center(child: ManageFAQ()),
    const Center(child: ManageForum()),
    const Center(child: ProfilePage()),
  ];

  void _popToInitialRoute(int index) {
    final NavigatorState navigator = _tabNavigators[index].currentState!;
    navigator.popUntil((route) => route.isFirst);
  }

  void switchTab(int tabIndex) {
    setState(() {
      _currentTabBar = tabIndex;
    });

    _popToInitialRoute(tabIndex);
  }
}
