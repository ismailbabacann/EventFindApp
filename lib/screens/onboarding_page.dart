import 'package:eventfindapp/screens/mainpage.dart';
import 'package:flutter/material.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  PageController _pageController = PageController();
  int currentPage = 0;


  void _onNextPage() {
    if (currentPage < 2) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 1),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void _onSkip() {
    Navigator.pushReplacementNamed(context, '/login');
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
              OnboardingStep(
                imagePath: 'lib/assets/icons/Onboarding 1.png',
              ),
              OnboardingStep(
                imagePath: 'lib/assets/icons/Onboarding 2.png',
              ),
              OnboardingStep(
                imagePath: 'lib/assets/icons/Onboarding 3.png',
              ),
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
                style: TextStyle(fontSize: 16, color: Colors.white , fontWeight: FontWeight.bold),
              ),
            )
                : SizedBox.shrink(),
          ),
          Positioned(
            right: 16,
            bottom: 120,
            child: IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));
              },
              icon: Icon(
                Icons.arrow_forward,
                color: Colors.transparent,
                size: 32,
              ),
            ),
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
          child: Image.asset(imagePath , fit: BoxFit.cover, width: screenWidth,),
        ),
      ],
    );
  }
}
