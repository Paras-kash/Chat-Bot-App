import 'package:flutter/material.dart';

class ResponsiveUtil {
  static bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < 600;
  
  static bool isTablet(BuildContext context) => 
      MediaQuery.of(context).size.width >= 600 && 
      MediaQuery.of(context).size.width < 1200;
  
  static bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= 1200;
  
  static double getScreenWidth(BuildContext context) => MediaQuery.of(context).size.width;
  
  static double getScreenHeight(BuildContext context) => MediaQuery.of(context).size.height;
  
  static double horizontalPadding(BuildContext context) {
    if (isMobile(context)) return 24;
    if (isTablet(context)) return 48;
    return 64; // desktop
  }
  
  static double verticalPadding(BuildContext context) {
    if (isMobile(context)) return 32;
    if (isTablet(context)) return 48;
    return 64; // desktop
  }
  
  static double getResponsiveFontSize(BuildContext context, {required double baseFontSize}) {
    if (isMobile(context)) return baseFontSize;
    if (isTablet(context)) return baseFontSize * 1.2;
    return baseFontSize * 1.3; // desktop
  }
  
  static double getRelativeWidth(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.width * percentage;
  }
  
  static double getRelativeHeight(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.height * percentage;
  }
}