import 'package:flutter/material.dart';
import 'package:dot_curved_bottom_nav/dot_curved_bottom_nav.dart';
import 'package:hire_me/cart_page.dart';
import 'package:hire_me/help_page.dart';
import 'package:hire_me/home.dart';

import '../view/profile_page_view.dart';

class CustomBottomAppBar extends StatefulWidget {
  const CustomBottomAppBar({Key? key}) : super(key: key);

  @override
  _CustomBottomAppBarState createState() => _CustomBottomAppBarState();
}

class _CustomBottomAppBarState extends State<CustomBottomAppBar> {
  int _currentPage = 0;
  final ScrollController _scrollController = ScrollController();

  void _updatePageIndex(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  late final List<Widget> _pages = [
    Home(controller: _scrollController),
    CartPage(scrollController: _scrollController),
    HelpScreen(scrollController: _scrollController,),
    ProfilePage(scrollController: _scrollController, updatePageIndex: _updatePageIndex),
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Ensures seamless bottom navigation
      extendBodyBehindAppBar: true,
      body: _pages[_currentPage],
      bottomNavigationBar: DotCurvedBottomNav(
        scrollController: _scrollController,
        hideOnScroll: true,
        indicatorColor: Colors.blue,
        backgroundColor: Colors.black.withOpacity(0.9),
        animationDuration: const Duration(milliseconds: 300),
        animationCurve: Curves.ease,
        selectedIndex: _currentPage,
        indicatorSize: 5,
        borderRadius: 25,
        height: 70,
        onTap: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        items: [
          Icon(
            Icons.home,
            color: _currentPage == 0 ? Colors.blue : Colors.white,
          ),
          Icon(
            Icons.text_snippet_outlined,
            color: _currentPage == 1 ? Colors.blue : Colors.white,
          ),
          Icon(
            Icons.help_outline_outlined,
            color: _currentPage == 2 ? Colors.blue : Colors.white,
          ),
          Icon(
            Icons.person,
            color: _currentPage == 3 ? Colors.blue : Colors.white,
          ),
        ],
      ),
    );
  }
}

// // Home page example
// class Home extends StatelessWidget {
//   final ScrollController controller;
//
//   const Home({required this.controller, Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       controller: controller,
//       itemCount: 30,
//       itemBuilder: (context, index) => ListTile(
//         title: Text('Home Item $index'),
//       ),
//     );
//   }
// }
