import 'package:eventfindapp/assets/theme/mycolors.dart';
import 'package:flutter/material.dart';
import 'package:eventfindapp/services/feedback_service.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final FeedbackService _feedbackService = FeedbackService();
  final TextEditingController _detailsController = TextEditingController();
  String? _selectedFeedbackType;

  final List<String> _feedbackTypes = [
    'Sorun ile ilgili yardım',
    'İyileştirme tavsiyesi',
    'Yorum ve eleştiri',
    'Etkinlik ilanı',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFEFF),
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text('Destek', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: _selectedFeedbackType,
              icon: Icon(Icons.notifications_active),
              hint: Text('Geri bildirim türünü seçin'),
              items: _feedbackTypes.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedFeedbackType = newValue;
                });
              },
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _detailsController,
              decoration: InputDecoration(
                hintText: 'Detaylandırınız...',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                final details = _detailsController.text.trim();
                if (_selectedFeedbackType != null && details.isNotEmpty) {
                  await _feedbackService.saveFeedback(
                    feedbackType: _selectedFeedbackType!,
                    feedbackDetails: details,
                  );
                  _detailsController.clear();
                  setState(() {
                    _selectedFeedbackType = null;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Geri bildirim gönderildi')));

                  await Future.delayed(Duration(milliseconds: 10));
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lütfen tüm alanları doldurun')));
                }
              },
              child: Text('Gönder', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: mainColor,
              ),
            ),
            SizedBox(height: 50,),
            Image.asset('lib/assets/icons/image 87 (1).png'),
          ],
        ),
      ),
    );
  }
}
