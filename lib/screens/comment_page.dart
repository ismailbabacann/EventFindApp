import 'package:eventfindapp/assets/theme/mycolors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommentPage extends StatefulWidget {
  final String eventName;

  CommentPage({required this.eventName});

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  TextEditingController commentController = TextEditingController();
  String? userName; // Kullanıcı adı

  @override
  void initState() {
    super.initState();
    _getUserName();
  }

  Future<void> _getUserName() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      setState(() {
        userName = userDoc.data()?['name'] ?? 'Anonim';
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(widget.eventName, style: TextStyle(color: Colors.white),),
        backgroundColor: mainColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.line_style_sharp),
                SizedBox(width: 5,),
                Text(
                  'Etkinlik Duvarı',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('events')
                    .doc(widget.eventName)
                    .collection('comments')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('Henüz yorum yapılmadı.'));
                  }

                  var comments = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (ctx, index) {
                      return ListTile(
                        leading: Icon(Icons.insert_comment_sharp , size: 45, color: mainColor,),
                        title: Text(comments[index]['comment'] , style: TextStyle(fontSize: 16),),
                        subtitle: Text(comments[index]['user'] , style: TextStyle(color: Colors.blueAccent),),
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      hintText: 'Yorum yaz...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () async {
                    if (commentController.text.isNotEmpty && userName != null) {
                      await FirebaseFirestore.instance
                          .collection('events')
                          .doc(widget.eventName)
                          .collection('comments')
                          .add({
                        'comment': commentController.text,
                        'user': userName, // Kullanıcı adı kaydediliyor
                        'timestamp': FieldValue.serverTimestamp(),
                      });
                      commentController.clear();
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
