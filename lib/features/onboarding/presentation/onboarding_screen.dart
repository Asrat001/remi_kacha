import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remi_kacha/core/constant.dart';
import 'package:remi_kacha/core/theme/app_theme.dart';
import 'package:remi_kacha/ui/widgets/onboarding/dot_indicator.dart';
import 'package:remi_kacha/ui/widgets/onboarding/onboarding_item.dart';
import 'package:remi_kacha/ui/widgets/rounded_button.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onFinish;
  const OnboardingScreen({super.key, required this.onFinish});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  final _pages = pages;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.background, // Change this color as needed
        statusBarIconBrightness: Brightness.dark, // Set brightness accordingly
        systemNavigationBarColor:
            AppColors.background, // Change bottom navigation color
      ),
    );
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      widget.onFinish();
    }
  }

  void _skip() {
    widget.onFinish();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _pages.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final page = _pages[index];
                    return OnboardingItem(pageData: page,);
                  },
                ),
              ),
              DotIndicator(
                listLength: _pages.length,
                currentPage: _currentPage,
              ),
              RoundedButton(
                label:
                    _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                onPressed: _nextPage,
              ),
              TextButton(onPressed: _skip, child: Text('Skip')),
            ],
          ),
        ),
      ),
    );
  }
}
