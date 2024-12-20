import 'package:flutter/widgets.dart';

class Responsive {
  final double screenWidth;
  final double screenHeight;
  final double devicePixelRatio;

  Responsive(BuildContext context)
      : screenWidth = MediaQuery.of(context).size.width,
        screenHeight = MediaQuery.of(context).size.height,
        devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

  /// Calculate width percentage of the screen
  double wp(double percentage) => screenWidth * (percentage / 100);

  /// Calculate height percentage of the screen
  double hp(double percentage) => screenHeight * (percentage / 100);

  /// Get the device aspect ratio
  double get aspectRatio => screenWidth / screenHeight;

  /// Scale font size based on screen width (optional multiplier)
  double sp(double fontSize, {double scaleFactor = 1}) {
    return (screenWidth * (fontSize / 100)) * scaleFactor;
  }
}
