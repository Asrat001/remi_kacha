import 'package:flutter/material.dart';

class DotIndicator extends StatelessWidget {
  final int listLength;
  final int currentPage;
  const DotIndicator({
    super.key,
    required this.listLength,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        listLength,
        (index) => Container(
          margin: EdgeInsets.symmetric(horizontal: 4, vertical: 16),
          width: 10,
          height: 10,
          decoration: BoxDecoration(shape: BoxShape.circle, color: currentPage == index
                              ? Theme.of(context).primaryColor
                              : Colors.grey[300]!,),
        ),
      ),
    );
  }
}
