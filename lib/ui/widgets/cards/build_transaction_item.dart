import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:remi_kacha/core/utils/date_utils.dart';


class BuildTransactionItem extends StatelessWidget {
  final String name;
  final String price;
  final String description;
  final Color bgColor;
  final String time;
  final String nameImage;

  const BuildTransactionItem({
    super.key,
    required this.name,
    required this.price,
    required this.description,
    required this.bgColor,
    required this.nameImage,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: bgColor.withOpacity(0.2),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      "assets/icons/$nameImage.svg",
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "To ${name}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        fontFamily: "Inter",
                      ),
                    ),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                      ),
                    ),
                    Text(
                      DateUtilsHelper.formatRelativeTime(time),
                      style: const TextStyle(
                        fontSize: 10,
                        fontFamily: "Inter",
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Text(
              "-\$$price",
              style: const TextStyle(
                fontSize: 14,
                fontFamily: "Inter",
                fontWeight: FontWeight.w700,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}