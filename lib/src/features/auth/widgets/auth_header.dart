import 'package:flutter/material.dart';
import 'package:fluttertest/src/core/models/utils/app_images.dart';

class AuthHeader extends StatelessWidget {
  final String imagePath;
  final String logoPath;
  final double height;
  final double logoScale;

  const AuthHeader({
    super.key,
    this.imagePath = AppImages.loginHeader,
    this.logoPath = AppImages.logo,
    this.height = 300.0,
    this.logoScale = 2.5,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(imagePath),
        Container(
          height: height,
        ),
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Image.asset(
            logoPath,
            scale: logoScale,
          ),
        ),
      ],
    );
  }
}
