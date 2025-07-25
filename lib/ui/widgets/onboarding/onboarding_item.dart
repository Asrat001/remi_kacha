import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:remi_kacha/core/constant.dart';

class OnboardingItem extends StatelessWidget {
  const OnboardingItem({super.key, required this.pageData});
  final OnboardingPageData pageData;
  @override
  Widget build(BuildContext context) {
  final mediaQuery = MediaQuery.of(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            pageData.svgPath,
            height:
                mediaQuery.orientation == Orientation.portrait
                    ? mediaQuery.size.width * 0.6
                    : mediaQuery.size.height * 0.6,
          ),
          SizedBox(height: 20),
          SizedBox(
            width: mediaQuery.size.width * 0.6,
            child: Text(
              pageData.title,
              style: Theme.of(
                context,
              ).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 20),
          Text(
            pageData.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w300,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
