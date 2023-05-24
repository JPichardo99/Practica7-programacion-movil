import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CardSchoolData {
  final String title;
  final String subtitle;
  final ImageProvider image;
  final Color backgroundColor;
  final Color titleColor;
  final Color subtitleColor;
  final Widget? background;

  CardSchoolData({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.backgroundColor,
    required this.titleColor,
    required this.subtitleColor,
    this.background,
  });
}

class CardSchool extends StatelessWidget {
  const CardSchool({
    required this.data,
    Key? key,
  }) : super(key: key);

  final CardSchoolData data;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (data.background != null) data.background!,
        Padding(
          padding: EdgeInsets.symmetric(vertical: 2.5.h, horizontal: 5.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 3),
              Flexible(
                flex: 25,
                child: Image(image: data.image),
              ),
              const Spacer(flex: 1),
              Text(
                data.title.toUpperCase(),
                style: TextStyle(
                    color: data.titleColor,
                    fontSize: 3.7.w,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 1),
              Text(
                data.subtitle,
                style: TextStyle(
                  color: data.subtitleColor,
                  fontSize: 2.7.w,
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
              ),
              const Spacer(flex: 14),
            ],
          ),
        ),
      ],
    );
  }
}
