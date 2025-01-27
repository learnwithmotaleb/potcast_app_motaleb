import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:podcast/presentation/screens/creator/podcast/my_podcast_screen.dart';
import 'package:podcast/presentation/screens/favorite/favorite_screen.dart';
import 'package:podcast/presentation/screens/history/history_screen.dart';
import 'package:podcast/presentation/screens/profile/profile_screen.dart';
import 'package:podcast/presentation/screens/user/home/user_home_screen.dart';

class CreatorNavScreen extends StatefulWidget {
  const CreatorNavScreen({super.key});

  @override
  State<CreatorNavScreen> createState() => _CreatorNavScreenState();
}

class _CreatorNavScreenState extends State<CreatorNavScreen> {
  int _selectedPage = 0;

  final List<Widget> _pages = [
    const UserHomeScreen(),
    const HistoryScreen(),
    const FavoriteScreen(),
    const MyPodcastScreen(isBack: false),
    const ProfileScreen(isUser: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPage],
      bottomNavigationBar: SizedBox(
        height: 80,
        child: BottomNavigationBar(
          currentIndex: _selectedPage,
          elevation: 10,
          backgroundColor: const Color(0xff151619),
          type: BottomNavigationBarType.fixed,
          onTap: (int index) {
            setState(() {
              _selectedPage = index;
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Iconsax.home, size: 32), label: ""),
            BottomNavigationBarItem(icon: Icon(Iconsax.clock, size: 32), label: ""),
            BottomNavigationBarItem(icon: Icon(Iconsax.lovely, size: 32), label: ""),
            BottomNavigationBarItem(icon: Icon(Iconsax.add, size: 32), label: ""),
            BottomNavigationBarItem(icon: Icon(Iconsax.user, size: 32), label: ""),
          ],
        ),
      ),
    );
  }
}
