import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:study_vault/features/notes/presentation/screens/home_screen.dart';
import 'package:study_vault/features/notes/presentation/screens/upload_screen.dart';
import 'package:study_vault/features/profile/presentation/screens/my_profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final pages = [
    const HomeScreen(),
    const Center(child: Text("Notes")),
    const UploadScreen(),
    const MyProfileScreen(),
  ];
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: index,
        onTap: (newIndex) {
          setState(() {
            index = newIndex;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Iconsax.home_2_copy),
            activeIcon: Icon(Iconsax.home_2),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.search_normal_copy, size: 24),
            activeIcon: Icon(Iconsax.search_normal, size: 24),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.document_upload_copy),
            activeIcon: Icon(Iconsax.document_upload),
            label: "Upload",
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.profile_circle_copy),
            activeIcon: Icon(Iconsax.profile_circle),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
