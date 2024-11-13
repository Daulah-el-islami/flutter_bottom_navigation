import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String hobby;
  final String address;
  final String birthdate;
  final String phone;

  const ProfilePage({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.hobby,
    required this.address,
    required this.birthdate,
    required this.phone,
  });

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  File? profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        profileImage = File(pickedFile.path);
      });
      _saveProfileImage();
    }
  }

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final String? imagePath = prefs.getString('profileImagePath');
    if (imagePath != null) {
      setState(() {
        profileImage = File(imagePath);
      });
    }
  }

  Future<void> _saveProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    if (profileImage != null) {
      prefs.setString('profileImagePath', profileImage!.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: profileImage != null
                      ? FileImage(profileImage!)
                      : const AssetImage('assets/default_profile.png')
                          as ImageProvider,
                  child: profileImage == null
                      ? Icon(Icons.camera_alt,
                          size: 30, color: Colors.white.withOpacity(0.7))
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              buildProfileInfo(
                  'Nama', '${widget.firstName} ${widget.lastName}'),
              buildProfileInfo('Hobi', widget.hobby),
              buildProfileInfo('Alamat', widget.address),
              buildProfileInfo('Tanggal Lahir', widget.birthdate),
              buildProfileInfo('Nomor Telepon', widget.phone),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProfileInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
