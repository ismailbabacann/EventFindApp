import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _image;
  final _nameController = TextEditingController(text: 'İsmail Babacan');
  final _aboutController = TextEditingController(
      text:
      'En sevdiğiniz yemeğin tadını çıkarın ve arkadaşlarınız ve ailenizle güzel vakit geçirin. Harika vakit geçirin. Yerel gıda kamyonlarından yiyecek satın alınabilecektir.');
  List<String> _interests = ['Others'];
  List<String> _allInterests = ['Games Online', 'Concert', 'Music', 'Art', 'Movie', 'Others', 'Travel', 'Books', 'Sports'];

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
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
                  decoration: InputDecoration(labelText: 'Ad Soyad'),
                ),
                TextField(
                  controller: _aboutController,
                  decoration: InputDecoration(labelText: 'Hakkımda'),
                  maxLines: 3,
                ),
                Align(
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
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {});
                  },
                  child: Text('Kaydet'),
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
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Profil'),
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
                  backgroundImage: _image != null ? FileImage(_image!) : NetworkImage('https://via.placeholder.com/150') as ImageProvider,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Icon(Icons.change_circle, color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                _nameController.text,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _editProfile,
                icon: Icon(Icons.edit),
                label: Text('Profili Düzenle'),
              ),
              SizedBox(height: 24),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Hakkımda',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 8),
              Text(
                _aboutController.text,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              SizedBox(height: 24),
              Align(
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
