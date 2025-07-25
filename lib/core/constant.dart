
import 'dart:convert';

import 'package:crypto/crypto.dart';

const double cPadding = 24.0;
const double cBorderRadius = 5.0;
const double cLineSize = 6.0;
const double cDotSize = 7.0;
const double cSelectedDotSize = 14.0;
const double elevation=4.0;

// Buttons
const double cButtonSize = 48.0;
const double cButtonPadding = 10.0;

const double cSplashRadius = 32.0;
const double cSmallSplashRadius = 24.0;

//hashmethod


String hash(String input) {
  return sha256.convert(utf8.encode(input)).toString();
}

// List Items
const double cListItemPadding = 18.0;
const double cListItemSpace = 12.0;

// Animations
const Duration cFastAnimationDuration = Duration(milliseconds: 150);
const Duration cTransitionDuration = Duration(milliseconds: 300);
const Duration cAnimationDuration = Duration(milliseconds: 500);
const Duration cAnimatedListDuration = Duration(milliseconds: 600);
//
String? emailValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Please enter an email address';
  }

  // Regular expression for email validation
  final emailRegex = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$',
    caseSensitive: false,
  );

  if (!emailRegex.hasMatch(value.trim())) {
    return 'Please enter a valid email address (e.g., user@domain.com)';
  }

  return null;
}
// BottomSheet
const double cBottomSheetBorderRadius = 28.0;


  final List<OnboardingPageData> pages = [
    OnboardingPageData(
      title: 'Welcome to RemiKacha',
      description: 'Send money easily and securely across borders.',
      svgPath: "assets/svgs/send.svg",
    ),
    OnboardingPageData(
      title: 'Track Your Wallet',
      description: 'View balances and recent transactions in real time.',
      svgPath:"assets/svgs/wallt.svg",
    ),
    OnboardingPageData(
      title: 'Exchange Rates',
      description: 'Convert currencies instantly with up-to-date rates.',
      svgPath:"assets/svgs/exchange.svg",
    ),
  ];

class OnboardingPageData {
  final String title;
  final String description;
  final String svgPath;
  const OnboardingPageData({
    required this.title,
    required this.description,
    required this.svgPath,
  });
}