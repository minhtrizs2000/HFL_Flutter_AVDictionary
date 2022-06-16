import 'package:avdictionary/screens/favorite/favorite_screen.dart';
import 'package:avdictionary/screens/offline_search/offline_search_screen.dart';
import 'package:avdictionary/screens/online_search/online_search_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'screens/offline_search/offline_search_screen.dart';
import 'screens/history/history_screen.dart';

class Navigation extends StatefulWidget {
  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedScreen = 0;

  final List<Widget> _screens = <Widget>[
    OfflineSearchScreen(),
    HistoryScreen(),
    FavoriteScreen(),
    OnlineSearchScreen(),
  ];

  late PageController _pageController;

  void _onItemTapped(int index) {
    setState(() {
      _selectedScreen = index;
      _pageController.jumpToPage(_selectedScreen);
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedScreen);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        //The following parameter is just to prevent
        //the user from swiping to the next page.
        physics: NeverScrollableScrollPhysics(),
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
            ),
          ],
        ),
        // ClipRRect to make boder of BottomNavigationBar rounded
        child: ClipRRect(
          child: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.search, color: Colors.white,),
                label: 'Search',
                backgroundColor: Colors.cyan,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.access_time, color: Colors.white,),
                label: 'History',
                backgroundColor: Colors.red,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.star_border_rounded, color: Colors.white,),
                label: 'Favorite',
                backgroundColor: Colors.cyan,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.public, color: Colors.white,),
                label: 'Online',
                backgroundColor: Colors.red,
              ),
            ],
            currentIndex: _selectedScreen,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.black,
            // reduce the extra padding on top and bottom of the nav bar
            // by set selectedFontSize and unselectedFontSize to 1.0
            selectedFontSize: 1,
            unselectedFontSize: 1,
            selectedIconTheme: const IconThemeData(
              size: 40,
            ),
            unselectedIconTheme: const IconThemeData(
              size: 20,
            ),
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
