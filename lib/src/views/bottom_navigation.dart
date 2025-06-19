import 'package:flutter/material.dart';
import 'package:tb_aufa/src/views/home_screen.dart';
import 'package:tb_aufa/src/views/explore_screen.dart';
import 'package:tb_aufa/src/views/saved_screen.dart';
import 'package:tb_aufa/src/views/profile_screen.dart';
import 'package:tb_aufa/src/views/sesarch_delegate.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({Key? key}) : super(key: key);

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 2; // Default ke Home
  late PageController _pageController;

  final List<Widget> _screens = const [
    ExploreScreen(),
    SavedScreen(),
    HomeScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  Widget _buildAnimatedIcon(IconData icon, int index, Color color) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return ScaleTransition(scale: animation, child: child);
      },
      child: Icon(
        icon,
        color: _currentIndex == index ? color : Colors.grey,
        key: ValueKey(icon),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TB_AUFA"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Aksi ketika search diklik
              showSearch(context: context, delegate: CustomSearchDelegate());
            },
          ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: _onItemTapped,
        itemCount: _screens.length,
        itemBuilder: (context, index) {
          return _screens[index];
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Explore
              IconButton(
                onPressed: () => _onItemTapped(0),
                icon: _buildAnimatedIcon(Icons.explore, 0, Colors.blue),
              ),

              // Saved
              IconButton(
                onPressed: () => _onItemTapped(1),
                icon: _buildAnimatedIcon(Icons.bookmark, 1, Colors.green),
              ),

              // Home (Centered)
              GestureDetector(
                onTap: () => _onItemTapped(2),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(Icons.home, color: Colors.white),
                ),
              ),

              // Profile
              IconButton(
                onPressed: () => _onItemTapped(3),
                icon: _buildAnimatedIcon(Icons.person, 3, Colors.purple),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
