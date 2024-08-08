import 'dart:io';
import 'package:flutter/material.dart';
import 'package:eventfindapp/screens/profile_page.dart';
import 'package:eventfindapp/screens/login_page.dart';
import 'package:flutter_svg/flutter_svg.dart';

File? _globalImage;

class CustomDrawer extends StatelessWidget {

  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: _globalImage != null
                      ? FileImage(_globalImage!)
                      : const NetworkImage('https://via.placeholder.com/150') as ImageProvider,
                ),
                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    'İsmail Babacan',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.co_present_rounded , color: Colors.grey,),
            title: const Text('Profil' , style: TextStyle(fontWeight: FontWeight.bold),),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.bookmark , color: Colors.grey,),
            title: const Text('Ayarlar' ,  style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.warning_rounded , color: Colors.grey,),
            title: const Text('Destek' ,  style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings , color: Colors.grey,),
            title: const Text('Şifreyi Değiştir' ,  style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app , color: Colors.grey,),
            title: const Text('Çıkış Yap' ,  style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
            },
          ),
          SizedBox(height: 60,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
             Image.asset('lib/assets/icons/group_34057__5_.png' , filterQuality: FilterQuality.high,),
            ],
          ),
        ],
      ),
    );
  }
}

