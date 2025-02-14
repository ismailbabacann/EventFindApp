import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eventfindapp/screens/mainpage.dart';

class OnboardingPage extends StatefulWidget {
  final bool isFromMenu; // Menüden mi açıldı?

  OnboardingPage({this.isFromMenu = false}); // Varsayılan olarak false

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  PageController _pageController = PageController();
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    if (!widget.isFromMenu) {
      _checkOnboardingStatus(); // İlk açılışsa onboarding kontrolü yap
    }
  }

  /// **Onboarding'in daha önce gösterilip gösterilmediğini kontrol et**
  void _checkOnboardingStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;

    if (onboardingCompleted) {
      Navigator.pushReplacementNamed(context, '/login'); // Daha önce gösterildiyse giriş sayfasına yönlendir
    }
  }

  /// **Onboarding tamamlandıysa kaydet ve giriş sayfasına yönlendir**
  void _completeOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);

    if (widget.isFromMenu) {
      Navigator.pop(context); // Menüden geldiyse geri dön
    } else {
      Navigator.pushReplacementNamed(context, '/login'); // İlk açılışsa login sayfasına yönlendir
    }
  }

  void _onNextPage() {
    if (currentPage < 2) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding(); // Onboarding tamamlanınca kaydet
    }
  }

  void _onSkip() {
    _completeOnboarding(); // Atlama butonuna basılınca onboarding tamamlanmış say
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                currentPage = page;
              });
            },
            children: [
              OnboardingStep(imagePath: 'lib/assets/icons/Onboarding 1.png'),
              OnboardingStep(imagePath: 'lib/assets/icons/Onboarding 2.png'),
              OnboardingStep(imagePath: 'lib/assets/icons/Onboarding 3.png'),
            ],
          ),
          Positioned(
            left: 16,
            bottom: 16,
            child: currentPage == 0
                ? TextButton(
              onPressed: _onSkip,
              child: Text(
                'Atla',
                style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            )
                : SizedBox.shrink(),
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: IconButton(
              onPressed: _onNextPage,
              icon: Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingStep extends StatelessWidget {
  final String imagePath;

  const OnboardingStep({
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Image.asset(imagePath, fit: BoxFit.cover, width: screenWidth),
        ),
      ],
    );
  }
}
