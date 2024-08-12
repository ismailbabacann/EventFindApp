import 'package:eventfindapp/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();
  final _nameController = TextEditingController();
  final _aboutController = TextEditingController();
  File? _selectedImage;
  String? _profileImageUrl;
  List<String> _interests = [];
  List<String> _allInterests = [
    'Games Online', 'Concert', 'Music', 'Art', 'Movie', 'Others', 'Travel', 'Books', 'Sports'
  ];

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    var profileData = await _authService.getUserProfile();
    if (profileData != null) {
      setState(() {
        _nameController.text = "${profileData['name']} ${profileData['surname']}";
        _aboutController.text = profileData['about'] ?? '';
        _interests = List<String>.from(profileData['interests'] ?? []);
        _profileImageUrl = profileData['profileImage'];
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _selectedImage = File(pickedFile.path);
      }
    });

    if (_selectedImage != null) {
      String? downloadUrl = await _authService.uploadProfileImage(_selectedImage!);
      if (downloadUrl != null) {
        await _authService.updateProfileImage(downloadUrl);
        setState(() {
          _profileImageUrl = downloadUrl;
        });
      }
    }
  }

  void _editProfile() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Ad Soyad'),
                ),
                TextField(
                  controller: _aboutController,
                  decoration: const InputDecoration(labelText: 'Hakkımda'),
                  maxLines: 3,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'İlgi Alanları',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: _allInterests.map((interest) {
                    final bool isSelected = _interests.contains(interest);
                    return FilterChip(
                      label: Text(interest),
                      selected: isSelected,
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            _interests.add(interest);
                          } else {
                            _interests.remove(interest);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                ElevatedButton(
                  onPressed: () async {
                    List<String> names = _nameController.text.split(' ');
                    await _authService.updateProfile(
                      names[0],
                      names.length > 1 ? names.sublist(1).join(' ') : '',
                      _aboutController.text,
                      _interests,
                    );
                    Navigator.pop(context);
                    setState(() {});
                  },
                  child: const Text('Kaydet'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Profil'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _profileImageUrl != null
                      ? NetworkImage(_profileImageUrl!)
                      : _selectedImage != null
                      ? FileImage(_selectedImage!) as ImageProvider
                      : const NetworkImage('https://via.placeholder.com/150'),
                  child: const Align(
                    alignment: Alignment.bottomRight,
                    child: Icon(Icons.change_circle, color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _nameController.text,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _editProfile,
                icon: const Icon(Icons.edit),
                label: const Text('Profili Düzenle'),
              ),
              const SizedBox(height: 24),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Hakkımda',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _aboutController.text,
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 24),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'İlgi Alanları',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: _interests.map((interest) => Chip(label: Text(interest))).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
