import 'package:flutter/material.dart';
// import 'package:rive_animation/constants.dart';

class FeatureListItem extends StatelessWidget {
  final Color backgroundColor;
  final String titleText;
  final String descriptionText;
  const FeatureListItem(
      {super.key,
        required this.backgroundColor,
        required this.titleText,
        required this.descriptionText});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 7).copyWith(right: 34),
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(14).copyWith(
              bottomLeft: Radius.zero, topLeft: const Radius.circular(29))),
      child: Column(
        children: [
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 14).copyWith(top: 14),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                titleText,
                style: const TextStyle(
                    fontFamily: 'Cera Pro',
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(
            height: 7,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(14.0).copyWith(top: 0, right: 29),
              child: Text(
                descriptionText,
                style: const TextStyle(
                    fontFamily: 'Cera Pro',
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.left,
              ),
            ),
          )
        ],
      ),
    );
  }
}