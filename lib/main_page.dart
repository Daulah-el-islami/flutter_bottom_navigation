import 'package:flutter/material.dart';
import 'home_page.dart';
import 'gallery_page.dart';
import 'profile_page.dart' as profile;

class MainPage extends StatefulWidget {
  final String firstName;
  final String lastName;

  const MainPage({super.key, required this.firstName, required this.lastName});

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  String _hobby = '';
  String _address = '';
  String _birthdate = '';
  String _phone = '';

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomePage(
        firstName: widget.firstName,
        lastName: widget.lastName,
        onSave: (String hobby, String address, String birthdate, String phone) {
          setState(() {
            _hobby = hobby;
            _address = address;
            _birthdate = birthdate;
            _phone = phone;
          });
          _onItemTapped(2);
        },
      ),
      const GalleryPage(),
      profile.ProfilePage(
        firstName: widget.firstName,
        lastName: widget.lastName,
        hobby: _hobby,
        address: _address,
        birthdate: _birthdate,
        phone: _phone,
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 2) {
        _pages[2] = profile.ProfilePage(
          firstName: widget.firstName,
          lastName: widget.lastName,
          hobby: _hobby,
          address: _address,
          birthdate: _birthdate,
          phone: _phone,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.image),
            label: 'Gallery',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
