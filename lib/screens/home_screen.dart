import 'package:flutter/material.dart';
import '../screens/cart_screen.dart';
import '../screens/clothing_list_screen.dart';
import '../screens/profile_screen.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _pages = [
    const ClothingListScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  void _onPageChanged(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onPageChanged,
      ),
    );
  }
}