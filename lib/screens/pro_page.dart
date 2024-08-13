import 'package:eventfindapp/assets/theme/mycolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ProPage extends StatelessWidget {


  void _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrlString(url.toString(), mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $urlString';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 60,
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              Text(
                "Premium Üyelik",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              // Placeholder for the logo
              Container(
                height:150,
                width: 150,
                child: SvgPicture.asset('lib/assets/icons/logo_enyakın.svg'),
              ),
              SizedBox(height: 5),
              Text(
                "Premium ile Sınırları Kaldır!",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: mainColor,
                ),
              ),
              SizedBox(height: 5),
              Column(
                children: [
                  FeatureTile("Tüm kullanıcılarla bağlantı kur!" ,),
                  FeatureTile("Etkinliğe kimlerin katıldığını görebilme!"),
                  FeatureTile("Premiuma özel etkinliklere katılma şansı!"),
                  FeatureTile("Premium'a özel indirimler ve hediyeler!"),
                ],
              ),
              SizedBox(height: 10),
              SubscriptionOptions(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await launchUrlString('', mode: LaunchMode.externalApplication);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainColor,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  "Ödeme Yap",
                  style: TextStyle(fontSize: 18 , color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeatureTile extends StatelessWidget {
  final String text;

  FeatureTile(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(Icons.check, color: Colors.blue),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

class SubscriptionOptions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SubscriptionOption("Aylık", "₺49,9", "TRY 49/ay"),
        SubscriptionOption("6 Aylık", "₺239,9", "TRY 39/ay", isHighlighted: true , ),
        SubscriptionOption("12 Aylık", "₺359,9", "TRY 29/ay"),
      ],
    );
  }
}

class SubscriptionOption extends StatelessWidget {
  final String title;
  final String price;
  final String subText;
  final bool isHighlighted;

  SubscriptionOption(this.title, this.price, this.subText, {this.isHighlighted = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: isHighlighted ? mainColor : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isHighlighted ? Colors.black : Colors.grey),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isHighlighted ? Colors.white : Colors.grey,
            ),
          ),
          SizedBox(height: 4),
          Text(
            price,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isHighlighted ? Colors.white : Colors.black,
            ),
          ),
          SizedBox(height: 4),
          Text(
            subText,
            style: TextStyle(
              fontSize: 14,
              color: isHighlighted ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
