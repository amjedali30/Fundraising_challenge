import 'package:flutter/material.dart';

class AppResponsiveSizes {
  final BuildContext context;
  double _screenWidth;
  double _screenHeight;

  AppResponsiveSizes(this.context)
      : _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;

  // Dynamic width size based on screen width
  double dynamicWidth(double width) => _screenWidth * (width / 100);

  // Dynamic height size based on screen height
  double dynamicHeight(double height) => _screenHeight * (height / 100);

  // Dynamic font size based on screen width
  double dynamicFont(double size) => _screenWidth * (size / 100);

  // Example usage for padding/margin
  EdgeInsets dynamicPadding(
      {double top = 0, double bottom = 0, double left = 0, double right = 0}) {
    return EdgeInsets.only(
      top: dynamicHeight(top),
      bottom: dynamicHeight(bottom),
      left: dynamicWidth(left),
      right: dynamicWidth(right),
    );
  }

  // Add other dynamic size methods as needed
}
